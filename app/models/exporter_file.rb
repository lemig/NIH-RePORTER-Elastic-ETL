require "open-uri"
require "zip"

class ExporterFile < ActiveRecord::Base
  TYPES = [
    'ProjectsFile',
    'AbstractsFile',
    'PublicationsFile',
    'PatentsFile',
    'ClinicalStudiesFile',
    'LinkTablesFile'
  ]

  def self.model
    raise "should be defined in subclass"
  end

  def self.sync_meta
    TYPES.each_with_index do |type, index|
      page_url = "https://exporter.nih.gov/ExPORTER_Catalog.aspx?index=#{index}"

      doc = Nokogiri::HTML(open(page_url))
      headers = doc.css("tr.txt_white td").map(&:text)
      rows = doc.css("tr.row_bg")

      rows.each do |row|
        name            = nil
        month           = nil
        year            = nil
        xml_path        = nil
        csv_path        = nil
        file_updated_at = nil
        processed       = false

        columns = row.css("td")

        columns.each_with_index do |column, index|
          header = headers[index]
          case header
          when 'Project File Name'
            name = column.text.strip
          when 'Month'
            month = column.text.strip
          when 'Fiscal Year'
            year = column.text.strip.to_i
          when 'XML'
            xml_path =  column.at_css('a')['href']
          when 'CSV'
            csv_path =  column.at_css('a')['href']
          when 'Last Updated Date'
            file_updated_at = Date.strptime(column.text.strip, '%m/%d/%Y')
          else
            raise "We should not be here"
          end
        end

        ef = find_or_initialize_by(type: type, xml_path: xml_path, csv_path: csv_path)

        processed = true if ef.processed && ef.file_updated_at >= file_updated_at

        ef.update(
          name: name,
          month: month,
          year: year,
          xml_path: xml_path,
          csv_path: csv_path,
          file_updated_at: file_updated_at,
          processed: processed
        )
      end
    end
  end


  def url
    "https://exporter.nih.gov/#{xml_path || csv_path}"
  end

  def xml?
    xml_path.present?
  end

  def csv?
    csv_path.present?
  end

  def content
    temp_file = open(url)
    unzipped_path = temp_file.path + "-unzipped"
    Zip::File.open(temp_file).first.extract(unzipped_path)
    open(unzipped_path)
  end

  def skipped_attributes
    []
  end

  def sync
    if xml?
      sync_xml
    else
      sync_csv
    end
    self.processed = true
    save!
  end

  def error_count
    record_count - extracted_records.count if record_count
  end

  protected

  def model
    self.class.model
  end

  def sync_xml
    batch = []
    record_count = 0
    not_persisted = 0

    Nokogiri::XML::Reader(content).each do |node|
      next unless node.name == 'row'
      row = Hash.from_xml(node.outer_xml)['row']
      next if row.blank?

      batch << attributes(row).merge(exporter_file_id: id).except(*skipped_attributes)

      if batch.size == 100
        begin
          models = model.create batch
          record_count       += models.count
          not_persisted += models.count{|m| !m.persisted?}
        rescue
          batch.each do |attr|
            begin
              model.create attr
            rescue
              not_persisted += 1
            ensure
              record_count += 1
            end
          end
        end
        puts "#{record_count} records, #{not_persisted} not persisted"
        batch.clear
      end
      self.record_count = record_count
      save!
    end
  end

  def sync_csv
    raise "should be defined in subclass"
  end

  def extracted_records
    raise "should be defined in subclass"
  end

  def attributes(row)
    attr = {}
    row.to_h.each do |key, value|
      key = key.underscore.parameterize.underscore.to_sym
      next if key == :xmlns_xsi
      value = attributes(value) if value.kind_of? Hash
      value.strip! if value.kind_of? String
      value = nil if value == { :xsi_nil => "true" }
      attr[key]= value
    end
    attr
  end
end

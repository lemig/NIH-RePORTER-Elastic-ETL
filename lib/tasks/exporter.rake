require 'open-uri'

namespace :exporter do
  task :sync_meta => :environment do
    entities_types = [
      'Projects',
      'Abstracts',
      'Publications',
      'Patents',
      'ClinicalStudies',
      'LinkTables'
    ]

    entities_types.each_with_index do |entities_type, index|
      page_url = "https://exporter.nih.gov/ExPORTER_Catalog.aspx?index=#{index}"

      doc = Nokogiri::HTML(open(page_url, proxy_http_basic_authentication: $proxy_http_basic_authentication))
      headers = doc.css("tr.txt_white td").map(&:text)
      rows = doc.css("tr.row_bg")

      rows.each do |row|
        name            = nil
        month           = nil
        year            = nil
        xml_path        = nil
        csv_path        = nil
        file_updated_at = nil

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

        exporter_file = ExporterFile.find_or_initialize_by(xml_path: xml_path, csv_path: csv_path)

        exporter_file.update(
          entities_type: entities_type,
          name: name,
          month: month,
          year: year,
          xml_path: xml_path,
          csv_path: csv_path,
          file_updated_at: file_updated_at
        )
      end
    end

    puts "Finished synchronizing Exporter metadata"
  end


  task :sync_data => :environment do
    ExporterFile.where(processed: false).each do |ef|
      case ef.entities_type
      when 'Projects'
        sync(Project, ef.content, except: "affiliation")
      # when 'Abstracts'
      #   sync(Abstract, content)
      # when 'Publications'
      #   sync(Publication, content)
      # when 'Patents'
      #   sync(Patent, content)
      # when 'ClinicalStudies'
      #   nil
      # when 'LinkTables'
      #   nil
      else
        nil
      end
    end
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

  def sync(model, content, args={})
    skipped_attributes = [args[:except]].flatten.compact.map(&:to_sym)
    puts "Processing"
    batch = []
    records = 0
    errors = 0

    Nokogiri::XML::Reader(content).each do |node|
        next unless node.name == 'row'
        row = Hash.from_xml(node.outer_xml)['row']
        next if row.blank?

        batch << attributes(row).except(*skipped_attributes)

        if batch.size == 100
          begin
            models = model.create batch
            records += models.count{|m| m.persisted?}
            errors += models.count{|m| !m.persisted?}
          rescue
            batch.each do |attr|
              begin
                model.create attr
                records += 1
              rescue
                errors += 1
              end
            end
          end
          puts "#{records} records, #{errors} errors"
          batch.clear
        end
      end
  end
end

require "open-uri"
require "zip"

class ExporterFile < ActiveRecord::Base
  def self.model
    raise "should be defined in subclass"
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
    temp_file = open(url, proxy_http_basic_authentication: $proxy_http_basic_authentication)
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

  protected

  def model
    self.class.model
  end

  def sync_xml
    puts "Processing #{name}"

    batch = []
    records = 0
    not_persisted = 0

    Nokogiri::XML::Reader(content).each do |node|
      next unless node.name == 'row'
      row = Hash.from_xml(node.outer_xml)['row']
      next if row.blank?

      batch << attributes(row).except(*skipped_attributes)

      if batch.size == 100
        begin
          models = model.create batch
          records += models.count{|m| m.persisted?}
          not_persisted += models.count{|m| !m.persisted?}
        rescue
          batch.each do |attr|
            begin
              model.create attr
              records += 1
            rescue
              not_persisted += 1
            end
          end
        end
        puts "#{records} records, #{not_persisted} not persisted"
        batch.clear
      end
    end
  end

  def sync_csv
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

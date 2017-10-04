require "open-uri"
require "zip"

class ExporterFile < ActiveRecord::Base

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
    Zip::File.open(temp_file).first.get_input_stream.read
  end
end

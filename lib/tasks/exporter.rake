require 'open-uri'

namespace :exporter do
  task :sync_meta => :environment do
    types = [
      'ProjectsFile',
      'AbstractsFile',
      'PublicationsFile',
      'PatentsFile',
      'ClinicalStudiesFile',
      'LinkTablesFile'
    ]

    types.each_with_index do |type, index|
      page_url = "https://exporter.nih.gov/ExPORTER_Catalog.aspx?index=#{index}"

      doc = Nokogiri::HTML(open(page_url, proxy_http_basic_authentication: $proxy_http_basic_authentication))
      headers = doc.css("tr.txt_white td").map(&:text)
      rows = doc.css("tr.row_bg")

      rows.each do |row|
        name            = nil
        month           = nil
        year            = nil
        xml_url         = nil
        csv_url         = nil
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
            xml_url =  column.at_css('a')['href']
          when 'CSV'
            csv_url =  column.at_css('a')['href']
          when 'Last Updated Date'
            file_updated_at = Date.strptime(column.text.strip, '%m/%d/%Y')
          else
            raise "We should not be here"
          end
        end

        exporter_file = ExporterFile.find_or_initialize_by(xml_url: xml_url, csv_url: csv_url)

        exporter_file.update(
          type: type,
          name: name,
          month: month,
          year: year,
          xml_url: xml_url,
          csv_url: csv_url,
          file_updated_at: file_updated_at
        )
      end
    end

    puts "Finished synchronizing Exporter metadata"
  end
end

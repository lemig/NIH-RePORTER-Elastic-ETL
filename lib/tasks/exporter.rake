require 'open-uri'

namespace :exporter do
  task :sync_meta => :environment do
    file_types = [
      'ProjectsFile',
      'AbstractsFile',
      'PublicationsFile',
      'PatentsFile',
      'ClinicalStudiesFile',
      'LinkTablesFile'
    ]

    file_types.each_with_index do |type, index|
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

        processed = false
        processed = true if exporter_file.processed && exporter_file.file_updated_at >= file_updated_at

        exporter_file = ExporterFile.find_or_initialize_by(type: type, xml_path: xml_path, csv_path: csv_path)

        exporter_file.update(
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

    puts "Finished synchronizing Exporter metadata"
  end


  task :sync_data => :environment do
    ExporterFile.where(processed: false).each do |ef|
      ef.sync
    end
  end
end

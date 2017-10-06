require 'open-uri'

namespace :exporter do
  task :sync_meta => :environment do
    ExporterFile.sync_meta
    puts "Finished synchronizing Exporter metadata"
  end


  task :sync_data => :environment do
    ExporterFile.where(processed: false).order("year DESC NULLS LAST, id ASC").each do |ef|
      puts "Processing #{ef.name}"
      ef.sync
    end
  end

  task :verify => :environment do
    ExporterFile.all.order(:id).each do |ef|
      puts "id #{ef.id}, processed:#{ef.processed}, records:#{ef.record_count}, errors:#{ef.error_count}, file:#{ef.name}"
    end
  end

  task :sync => [:sync_meta, :sync_data, :verify]
end

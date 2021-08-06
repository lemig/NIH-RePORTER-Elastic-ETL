require 'open-uri'

namespace :sync do
  task :meta => :environment do
    puts "Started synchronizing Exporter metadata"
    ExporterFile.sync_meta
    puts "Finished synchronizing Exporter metadata"
  end


  task :data => :environment do
    puts "Started synchronizing Exporter data"
    ExporterFile.where(processed: false).order("year DESC NULLS LAST, id ASC").each do |ef|
      puts "Processing #{ef.name}"
      ef.sync
    end
    puts "Finished synchronizing Exporter data"
  end

  task :verify => :environment do
    puts "Started verifying data extraction"
    path = "#{Rails.root}/log/sync.log"

    File.open(path, 'w') do |file|
      ExporterFile.all.order(:id).each do |ef|
        text = "id #{ef.id}, processed:#{ef.processed}, records:#{ef.record_count}, errors:#{ef.error_count}, file:#{ef.name}"
        file.write(text)
        puts text
      end
    end

    puts "Finished verifying data extraction"
    puts "=> #{path}"
  end

  task :all => [:meta, :data]
end

import "#{__dir__}/extract.rake"
import "#{__dir__}/projects.rake"
import "#{__dir__}/organizations.rake"

task :sync => ["sync:all", "extract:entities", "projects:fix", "organizations:enrich"]

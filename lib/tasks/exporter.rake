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
    puts "Finished synchronizing Exporter data"
  end

  task :verify => :environment do
    ExporterFile.all.order(:id).each do |ef|
      puts "id #{ef.id}, processed:#{ef.processed}, records:#{ef.record_count}, errors:#{ef.error_count}, file:#{ef.name}"
    end
    puts "Finished verification"
  end

  task :extract_organizations => :environment do
    count = 0
    Project.includes(:organizations).find_each do |project|
      next if project.organizations.any?

      count += 1
      dunses = project.org_duns.to_s.split(/;\s?/)
      orgs = []

      if dunses.none?
        if project.org_name.present?
          orgs << Organization.find_or_initialize_by(name: project.org_name)
        end
      else
        dunses.each do |duns|
          orgs << Organization.find_or_initialize_by(duns: duns)
        end
      end

      orgs.each do |org|
        org.name ||= project.org_name
        org.city = project.org_city
        org.state ||= project.org_state
        org.zip ||= project.org_zipcode
        org.country ||= project.org_fips
        org.ipf_code ||= project.org_ipf_code
        org.projects << project unless project.in? org.projects
        org.save!
      end
      puts count if count % 1000 == 0
    end
    puts "Finished extracting organizations"
  end

  task :sync => [:sync_meta, :sync_data, :verify, :extract_organizations]
end

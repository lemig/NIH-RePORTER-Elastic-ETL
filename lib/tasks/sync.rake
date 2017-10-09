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
    ExporterFile.all.order(:id).each do |ef|
      puts "id #{ef.id}, processed:#{ef.processed}, records:#{ef.record_count}, errors:#{ef.error_count}, file:#{ef.name}"
    end
    puts "Finished verifying data extraction"
  end

  task :organizations => :environment do
    puts "Started organization extraction"
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
    puts "Finished organization extraction"
  end

  task :sam => :environment do
    puts "Started retrieving organization info from SAM.GOV"
    Organization.where(address: nil).where.not(duns:nil).find_each do |organization|
      info = organization.get_info
      organization.update! info
      print '.'
      sleep 0.2
    end
    puts "Finished retrieving organization info from SAM.GOV"
  end

  task :geocode => :environment do
    puts "Started geocoding organizations"
    Organization.where("(city IS NOT NULL OR address IS NOT NULL) AND lat IS NULL").find_each do |organization|
      coordinates = Geocoder.geocode organization.full_address
      organization.update! coordinates unless coordinates.blank?
      print '.'
      sleep 0.2
    end
    puts "Finished geocoding organizations"
  end

  task :all => [:meta, :data, :verify, :organizations, :sam, :geocode]
end

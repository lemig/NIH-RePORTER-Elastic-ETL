namespace :organizations do
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

  task :enrich => [:sam, :geocode]
end

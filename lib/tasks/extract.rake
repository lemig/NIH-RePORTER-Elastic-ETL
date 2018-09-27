namespace :extract do
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

  task :principal_investigators => :environment do
    puts "Started extracting principal investigators"
    Project.all.includes(:people).find_each do |project|
      next if project.pis.blank?
      next if project.people.any?

      pis = project.pis["pi"]
      pis = [pis] unless pis.kind_of? Array

      pis.each do |pi|
        pi_name = pi['PI_NAME'] || pi['pi_name']
        pi_id = pi['PI_ID'] || pi['pi_id']

        next if pi_name.blank?
        next if pi_id.blank?

        pi_name = pi_name.to_s.gsub('(contact)', '').strip
        pi_id = pi_id.to_s.gsub('(contact)', '').strip.to_i

        begin
          person = Person.find_or_create_by pi_id: pi_id, name: pi_name
        rescue ActiveRecord::RecordNotUnique
          # Sometime small name diffs: "COX, NANCY J." vs "COX, NANCY J"
          person = Person.find_by pi_id: pi_id
          puts "#{person.name} vs #{pi_name}"
        rescue Exception => e
          byebug
          print 'e'
        end

        person.projects << project unless project.in? person.projects
        person.save
        print '.'
      end
    end
    puts "Finished extracting principal investigators"
  end

  task :authors => :environment do
    puts "Started extracting authors"
    Publication.joins("LEFT JOIN people_publications ON publications.id = people_publications.publication_id")
               .where("people_publications.person_id IS NULL")
               .find_each do |publication|
      publication.author_names.each do |name|
        begin
          person = Person.find_or_create_by pi_id: nil, name: name
          person.publications << publication unless publication.in? person.publications
          person.save
          print '.'
        rescue
          print 'e'
        end
      end
    end
    puts "Finished extracting authors"
  end

  task :entities => [:organizations, :principal_investigators, :authors]
end

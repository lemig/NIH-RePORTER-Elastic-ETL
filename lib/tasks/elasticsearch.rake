namespace :es do
  desc "Index a model (Project, Person, Publication, Patent, ClinicalStudy, Organization) from scratch in Elasticsearch."
  task :import, [:model] => :environment do |t, args|
    model = args[:model].constantize

    case model.name
    when 'Project'
      Rake::Task['es:import_projects'].invoke
      return
    end

    type = model.mappings.type
    mappings = JSON.parse(File.read("#{Rails.root}/app/mappings/#{type}.json"))

    index_name = model.index_name

    $es.indices.delete index: index_name if $es.indices.exists?(index: index_name)

    $es.indices.create(
      index: index_name,
      body: {
        settings: $es_settings,
        mappings: mappings
      }
    )

    model.import
    puts "finished import of #{model}"
  end


  desc "Index a Project into separate indices."
  task :import_projects => :environment do
    model = Project
    type = 'nih_project'
    mappings = JSON.parse(File.read("#{Rails.root}/app/mappings/#{type}.json"))

    [:main, :sub].each do |scope|
      index_name = "nih_projects_#{scope}"

      $es.indices.delete index: index_name if $es.indices.exists?(index: index_name)

      $es.indices.create(
        index: index_name,
        body: {
          settings:  $es_settings,
          mappings: mappings
        }
      )

      transform = lambda do |p|
        {index: {_id: p.id, data: p.as_indexed_project_json}}
      end

      Project.import index: index_name, type: type, scope: scope, transform: transform

      puts "finished import of Project #{scope}"
    end
  end


  desc "Index a Project into separate indices."
  task :import_applications => :environment do
    settings = JSON.parse(File.read("#{Rails.root}/config/settings/applications.json"))
    mappings = JSON.parse(File.read("#{Rails.root}/config/mappings/application.json"))

    cli = Project.__elasticsearch__.client

    index_name = "applications"

    cli.indices.delete index: index_name if cli.indices.exists?(index: index_name)

    cli.indices.create(
      index: index_name,
      body: {
        settings: settings,
        mappings: mappings
      }
    )

    Project.import index: index_name, type: "application"

    puts "finished import of Project"
  end
end

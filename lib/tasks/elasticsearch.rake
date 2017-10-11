namespace :es do
  desc "Index a model (Project, Person, Publication, Patent, ClinicalStudy, Organization) from scratch in Elasticsearch."
  task :import, [:model] => :environment do |t, args|
    model = args[:model].constantize

    mappings = JSON.parse(File.read("#{Rails.root}/app/mappings/#{args[:model].underscore}.json"))

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
end

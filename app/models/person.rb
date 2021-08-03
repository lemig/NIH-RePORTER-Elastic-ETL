class Person < ActiveRecord::Base
  include Indexable
  
  include Elasticsearch::Model

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :publications

  def as_indexed_json(options={})
    as_json except: [
              :updated_at,
              :created_at
            ],
            methods:[
              :pmid
            ]
  end

  def pmid
    publications.pluck(:pmid)
  end
end

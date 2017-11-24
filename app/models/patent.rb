class Patent < ActiveRecord::Base
  include Indexable

  serialize :core_project_num, Array

  belongs_to :exporter_file
  has_many :project_patents, primary_key: :patent_id, foreign_key: :patent_id
  has_many :projects, through: :project_patents

  def project_core_num
    project_patents.pluck(:project_id)
  end

  def as_indexed_json(options={})
    as_json except: [
              :updated_at,
              :created_at
            ],
            methods: [
              :project_core_num
            ]
  end
end

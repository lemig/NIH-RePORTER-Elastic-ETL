class ProjectPublication < ActiveRecord::Base
  belongs_to :exporter_file
  belongs_to :publication, primary_key: :pmid, foreign_key: :pmid
  has_many :projects, primary_key: :project_number, foreign_key: :core_project_num
end

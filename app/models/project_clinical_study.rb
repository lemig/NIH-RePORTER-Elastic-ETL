class ProjectClinicalStudy < ActiveRecord::Base
  belongs_to :exporter_file
  belongs_to :clinical_study, primary_key: :clinical_trials_gov_id, foreign_key: :clinical_trials_gov_id
  has_many :projects, primary_key: :core_project_number, foreign_key: :core_project_num
end

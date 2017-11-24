class ClinicalStudy < ActiveRecord::Base
  include Indexable

  belongs_to :exporter_file
  has_many :project_clinical_studies,primary_key: :clinical_trials_gov_id, foreign_key: :clinical_trials_gov_id
  has_many :projects, through: :project_clinical_studies

  def core_project_num
    project_clinical_studies.pluck(:core_project_number)
  end

  def as_indexed_json(options={})
    as_json(
      except: [
        :updated_at,
        :created_at
      ],
      methods: [
        :core_project_num
      ]
    )
  end
end

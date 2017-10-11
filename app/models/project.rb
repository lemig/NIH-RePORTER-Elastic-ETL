class Project < ActiveRecord::Base
  include Indexable

  serialize :pis, JSON
  serialize :project_terms, JSON
  serialize :nih_spending_cats, JSON

  belongs_to :exporter_file
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :people
  has_many :project_patents, primary_key: :core_project_num, foreign_key: :project_id
  has_many :patents, through: :project_patents
  has_many :project_clinical_studies, primary_key: :core_project_num, foreign_key: :core_project_number
  has_many :clinical_studies, through: :project_clinical_studies
  has_many :project_publications, primary_key: :core_project_num, foreign_key: :project_number
  has_many :publications, through: :project_publications
  has_one :abstract, primary_key: :application_id, foreign_key: :application_id

  join_sql = %[
    LEFT JOIN (
      SELECT core_project_num, subproject_id, MAX(application_id) AS max_application_id
      FROM projects
      GROUP BY core_project_num, subproject_id
    ) m ON projects.application_id = m.max_application_id
  ]

  scope :former, -> { joins(join_sql).where('max_application_id IS NULL') }
  scope :latest, -> { joins(join_sql).where('max_application_id IS NOT NULL') }
  scope :main, -> { latest.where('projects.subproject_id IS NULL') }
  scope :sub, -> { latest.where('projects.subproject_id IS NOT NULL') }

  def as_indexed_json(options={})
    as_json except: [
              :org_city,
              :org_country,
              :org_dept,
              :org_district,
              :org_duns,
              :org_fips,
              :org_name,
              :org_state,
              :org_zipcode,
              :updated_at,
              :created_at,
              :pis,
              :project_termsx
            ],
            methods: [
              :abstract_text,
              :organization_ids,
              :pi_id,
              :cpn_sp_id
            ]
  end

  def as_indexed_project_json
    application_only_keys = ["application_type", "award_notice_date", "budget_start", "budget_end", "foa_number", "full_project_num", "fy", "support_year", "suffix", "direct_cost_amt", "indirect_cost_amt", "total_cost", "total_cost_sub_project", "is_latest_application"]
    as_indexed_json.except application_only_keys
  end

  def pi_id
    people.pluck(:pi_id)
  end

  def abstract_text
    abstract.try :abstract_text
  end

  def cpn_sp_id
    [core_project_num, subproject_id].compact.map(&:to_s).join(' : ')
  end
end

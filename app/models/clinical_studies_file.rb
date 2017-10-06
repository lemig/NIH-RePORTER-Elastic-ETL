class ClinicalStudiesFile < ExporterFile
  has_many :clinical_studies, :foreign_key => :exporter_file_id
  has_many :project_clinical_studies, :foreign_key => :exporter_file_id

  alias_method :extracted_records, :clinical_studies

  def sync_csv
    ProjectClinicalStudy.delete_all
    ClinicalStudy.delete_all
    CSV.parse(content, headers: true) do |row|
      attributes = attributes(row)
      ProjectClinicalStudy.find_or_create_by attributes.slice(:core_project_number, :clinical_trials_gov_id, :exporter_file_id)
      clinical_study = ClinicalStudy.find_or_initialize_by attributes.slice(:clinical_trials_gov_id, :exporter_file_id)
      clinical_study.update attributes.except(:core_project_number)
      print '.'
    end
  end
end

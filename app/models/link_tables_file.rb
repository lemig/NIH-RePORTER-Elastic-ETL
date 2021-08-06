class LinkTablesFile < ExporterFile
  has_many :project_publications, :foreign_key => :exporter_file_id

  alias_method :extracted_records, :project_publications

  def self.model
    ProjectPublication
  end
end

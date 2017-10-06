class ProjectsFile < ExporterFile
  has_many :projects, :foreign_key => :exporter_file_id

  alias_method :extracted_records, :projects

  def self.model
    Project
  end
end

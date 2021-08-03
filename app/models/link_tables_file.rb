class LinkTablesFile < ExporterFile
  has_many :project_publications, :foreign_key => :exporter_file_id

  alias_method :extracted_records, :project_publications

  def self.model
    ProjectPublication
  end

  def sync_csv
    CSV.parse(content, headers: true) do |row|
      attributes = attributes(row)
      model.find_or_create_by attributes
      print '.'
    end
  end
end

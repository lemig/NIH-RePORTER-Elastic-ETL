require "csv"

class PatentsFile < ExporterFile
  has_many :project_patents, :foreign_key => :exporter_file_id
  has_many :patents, :foreign_key => :exporter_file_id

  alias_method :extracted_records, :patents

  def sync_csv
    ProjectPatent.delete_all
    Patent.delete_all
    csv = content.read.scrub
    CSV.parse(csv, headers: true) do |row|
      attributes = attributes(row)
      ProjectPatent.find_or_create_by attributes.slice(:patent_id, :project_id, :exporter_file_id)
      patent = Patent.find_or_initialize_by attributes.slice(:patent_id, :exporter_file_id)
      patent.update attributes.except(:project_id)
      print '.'
    end
  end
end

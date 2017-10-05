require "csv"

class PatentsFile < ExporterFile
  def sync_csv
    ProjectPatent.delete_all
    Patent.delete_all
    CSV.parse(content, headers: true) do |row|
      attributes = attributes(row)
      ProjectPatent.find_or_create_by attributes.slice(:patent_id, :project_id)
      patent = Patent.find_or_initialize_by attributes.slice(:patent_id)
      patent.update attributes.except(:project_id)
      print '.'
    end
  end
end

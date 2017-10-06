class AbstractsFile < ExporterFile
  has_many :abstracts, :foreign_key => :exporter_file_id

  alias_method :extracted_records, :abstracts

  def self.model
    Abstract
  end
end

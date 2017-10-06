class PublicationsFile < ExporterFile
  has_many :publications, :foreign_key => :exporter_file_id

  alias_method :extracted_records, :publications

  def self.model
    Publication
  end

  def skipped_attributes
    [:affiliation]
  end
end

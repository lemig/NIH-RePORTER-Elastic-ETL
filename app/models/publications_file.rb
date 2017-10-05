class PublicationsFile < ExporterFile
  def self.model
    Publication
  end

  def skipped_attributes
    [:affiliation]
  end
end

class AddExporterFileIdToModels < ActiveRecord::Migration
  def change
    add_reference :abstracts, :exporter_file, index: true
    add_reference :clinical_studies, :exporter_file, index: true
    add_reference :patents, :exporter_file, index: true
    add_reference :projects, :exporter_file, index: true
    add_reference :publications, :exporter_file, index: true
    add_reference :project_patents, :exporter_file, index: true
    add_reference :project_publications, :exporter_file, index: true
    add_reference :project_clinical_studies, :exporter_file, index: true
  end
end

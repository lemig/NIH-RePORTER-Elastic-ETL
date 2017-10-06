class AddRecordCountToExporterFiles < ActiveRecord::Migration
  def change
    add_column :exporter_files, :record_count, :integer
  end
end

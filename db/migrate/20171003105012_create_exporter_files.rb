class CreateExporterFiles < ActiveRecord::Migration
  def change
    create_table :exporter_files do |t|
      t.string :name
      t.string :month
      t.integer :year
      t.string :xml_path
      t.string :csv_path
      t.datetime :file_updated_at, index: true
      t.boolean :processed, index: true, default: false
      t.string :entities_type, index: true

      t.timestamps null: false
    end

    add_index :exporter_files, [:xml_path, :csv_path], unique: true
  end
end

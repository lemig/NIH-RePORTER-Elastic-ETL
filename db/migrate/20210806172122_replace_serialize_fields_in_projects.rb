class ReplaceSerializeFieldsInProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :terms, :string, default: [], array: true
    remove_column :projects, :project_terms
  end
end

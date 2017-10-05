class CreateProjectPatents < ActiveRecord::Migration
  def change
    create_table "project_patents", force: :cascade do |t|
      t.string   "patent_id"
      t.string   "project_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "project_patents", ["patent_id", "project_id"], name: "index_project_patents", unique: true, using: :btree
  end
end

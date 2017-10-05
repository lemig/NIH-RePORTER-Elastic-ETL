class CreateProjectPublications < ActiveRecord::Migration
  def change
    create_table "project_publications", force: :cascade do |t|
      t.integer  "pmid"
      t.string   "project_number"
      t.datetime "created_at",     null: false
      t.datetime "updated_at",     null: false
    end

    add_index "project_publications", ["pmid", "project_number"], name: "index_project_publications_on_pmid_and_project_number", unique: true, using: :btree
    add_index "project_publications", ["pmid"], name: "index_project_publications_on_pmid", using: :btree
    add_index "project_publications", ["project_number"], name: "index_project_publications_on_project_number", using: :btree
  end
end

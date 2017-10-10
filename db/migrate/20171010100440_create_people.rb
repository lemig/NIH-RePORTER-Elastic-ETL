class CreatePeople < ActiveRecord::Migration
  def change
    create_table "people", force: :cascade do |t|
      t.string   "name"
      t.integer  "pi_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "people", ["name"], name: "index_people_on_name", using: :btree
    add_index "people", ["pi_id", "name"], name: "index_people_on_pi_id_and_name", unique: true, using: :btree
    add_index "people", ["pi_id"], name: "index_people_on_pi_id", unique: true, using: :btree

    create_table "people_projects", id: false, force: :cascade do |t|
      t.integer "person_id",  null: false
      t.integer "project_id", null: false
    end

    add_index "people_projects", ["person_id", "project_id"], name: "index_people_projects_on_person_id_and_project_id", unique: true, using: :btree
    add_index "people_projects", ["project_id", "person_id"], name: "index_people_projects_on_project_id_and_person_id", unique: true, using: :btree

    create_table "people_publications", id: false, force: :cascade do |t|
      t.integer "person_id",      null: false
      t.integer "publication_id", null: false
    end

    add_index "people_publications", ["person_id", "publication_id"], name: "index_people_publications_on_person_id_and_publication_id", unique: true, using: :btree
    add_index "people_publications", ["publication_id", "person_id"], name: "index_people_publications_on_publication_id_and_person_id", unique: true, using: :btree
  end
end

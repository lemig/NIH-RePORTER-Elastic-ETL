class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table "organizations", force: :cascade do |t|
      t.string   "duns"
      t.string   "ipf_code"
      t.string   "name"
      t.string   "address"
      t.string   "zip"
      t.string   "state"
      t.string   "country"
      t.float    "lat"
      t.float    "lon"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string   "city"
    end

    add_index "organizations", ["country"], name: "index_organizations_on_country", using: :btree
    add_index "organizations", ["duns", "name"], name: "index_organizations_on_duns_and_name", unique: true, using: :btree
    add_index "organizations", ["duns"], name: "index_organizations_on_duns", unique: true, using: :btree
    add_index "organizations", ["ipf_code"], name: "index_organizations_on_ipf_code", using: :btree

    create_table "organizations_projects", id: false, force: :cascade do |t|
      t.integer "organization_id", null: false
      t.integer "project_id",      null: false
    end

    add_index "organizations_projects", ["organization_id", "project_id"], name: "index_organizations_projects_on_organization_id_and_project_id", unique: true, using: :btree
    add_index "organizations_projects", ["project_id", "organization_id"], name: "index_organizations_projects_on_project_id_and_organization_id", unique: true, using: :btree
  end
end

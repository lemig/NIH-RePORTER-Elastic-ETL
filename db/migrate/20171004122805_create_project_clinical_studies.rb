class CreateProjectClinicalStudies < ActiveRecord::Migration
  def change
    create_table "project_clinical_studies", force: :cascade do |t|
      t.string   "core_project_number"
      t.string   "clinical_trials_gov_id"
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
    end

    add_index "project_clinical_studies", ["core_project_number", "clinical_trials_gov_id"], name: "index_project_clinical_studies", unique: true, using: :btree
  end
end

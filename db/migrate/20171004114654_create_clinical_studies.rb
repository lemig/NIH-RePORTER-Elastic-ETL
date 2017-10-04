class CreateClinicalStudies < ActiveRecord::Migration
  def change
    create_table "clinical_studies", force: :cascade do |t|
      t.string   "clinical_trials_gov_id"
      t.text     "study"
      t.string   "study_status"
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
    end

    add_index "clinical_studies", ["clinical_trials_gov_id"], name: "index_clinical_studies_on_clinical_trials_gov_id", unique: true, using: :btree
    add_index "clinical_studies", ["study_status"], name: "index_clinical_studies_on_study_status", using: :btree
  end
end

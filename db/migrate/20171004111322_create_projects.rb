class CreateProjects < ActiveRecord::Migration
  def change
      create_table "projects", force: :cascade do |t|
        t.integer  "application_id"
        t.string   "activity"
        t.string   "administering_ic"
        t.string   "application_type"
        t.string   "arra_funded"
        t.date     "award_notice_date"
        t.date     "budget_start"
        t.date     "budget_end"
        t.string   "cfda_code"
        t.string   "core_project_num"
        t.string   "ed_inst_type"
        t.string   "foa_number"
        t.string   "full_project_num"
        t.string   "funding_i_cs"
        t.string   "funding_mechanism"
        t.integer  "fy"
        t.string   "ic_name"
        t.string   "nih_spending_cats"
        t.string   "org_city"
        t.string   "org_country"
        t.string   "org_dept"
        t.string   "org_district"
        t.string   "org_duns"
        t.string   "org_fips"
        t.string   "org_name"
        t.string   "org_state"
        t.string   "org_zipcode"
        t.text     "phr"
        t.text     "pis"
        t.string   "program_officer_name"
        t.date     "project_start"
        t.date     "project_end"
        t.text     "project_termsx"
        t.string   "project_title"
        t.string   "serial_number"
        t.string   "study_section"
        t.string   "study_section_name"
        t.integer  "subproject_id"
        t.string   "support_year"
        t.string   "suffix"
        t.integer  "direct_cost_amt"
        t.integer  "indirect_cost_amt"
        t.integer  "total_cost"
        t.integer  "total_cost_sub_project"
        t.datetime "created_at",             null: false
        t.datetime "updated_at",             null: false
        t.text     "project_terms"
      end

      add_index "projects", ["application_id"], name: "index_projects_on_application_id", unique: true, using: :btree
      add_index "projects", ["core_project_num"], name: "index_projects_on_core_project_num", using: :btree
      add_index "projects", ["org_name"], name: "index_projects_on_org_name", using: :btree
      add_index "projects", ["program_officer_name"], name: "index_projects_on_program_officer_name", using: :btree
  end
end

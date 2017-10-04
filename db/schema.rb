# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171004111322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exporter_files", force: :cascade do |t|
    t.string   "name"
    t.string   "month"
    t.integer  "year"
    t.string   "xml_path"
    t.string   "csv_path"
    t.datetime "file_updated_at"
    t.boolean  "processed",       default: false
    t.string   "entities_type"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "exporter_files", ["entities_type"], name: "index_exporter_files_on_entities_type", using: :btree
  add_index "exporter_files", ["file_updated_at"], name: "index_exporter_files_on_file_updated_at", using: :btree
  add_index "exporter_files", ["processed"], name: "index_exporter_files_on_processed", using: :btree
  add_index "exporter_files", ["xml_path", "csv_path"], name: "index_exporter_files_on_xml_path_and_csv_path", unique: true, using: :btree

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

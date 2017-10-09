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

ActiveRecord::Schema.define(version: 20171006144506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abstracts", force: :cascade do |t|
    t.integer  "application_id"
    t.text     "abstract_text"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "exporter_file_id"
  end

  add_index "abstracts", ["application_id"], name: "index_abstracts_on_application_id", unique: true, using: :btree
  add_index "abstracts", ["exporter_file_id"], name: "index_abstracts_on_exporter_file_id", using: :btree

  create_table "clinical_studies", force: :cascade do |t|
    t.string   "clinical_trials_gov_id"
    t.text     "study"
    t.string   "study_status"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "exporter_file_id"
  end

  add_index "clinical_studies", ["clinical_trials_gov_id"], name: "index_clinical_studies_on_clinical_trials_gov_id", unique: true, using: :btree
  add_index "clinical_studies", ["exporter_file_id"], name: "index_clinical_studies_on_exporter_file_id", using: :btree
  add_index "clinical_studies", ["study_status"], name: "index_clinical_studies_on_study_status", using: :btree

  create_table "exporter_files", force: :cascade do |t|
    t.string   "name"
    t.string   "month"
    t.integer  "year"
    t.string   "xml_path"
    t.string   "csv_path"
    t.datetime "file_updated_at"
    t.boolean  "processed",       default: false
    t.string   "type"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "record_count"
  end

  add_index "exporter_files", ["file_updated_at"], name: "index_exporter_files_on_file_updated_at", using: :btree
  add_index "exporter_files", ["processed"], name: "index_exporter_files_on_processed", using: :btree
  add_index "exporter_files", ["type"], name: "index_exporter_files_on_type", using: :btree
  add_index "exporter_files", ["xml_path", "csv_path"], name: "index_exporter_files_on_xml_path_and_csv_path", unique: true, using: :btree

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

  create_table "patents", force: :cascade do |t|
    t.string   "patent_title"
    t.string   "patent_org_name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "patent_id"
    t.integer  "exporter_file_id"
  end

  add_index "patents", ["exporter_file_id"], name: "index_patents_on_exporter_file_id", using: :btree
  add_index "patents", ["patent_id"], name: "index_patents_on_patent_id", using: :btree

  create_table "project_clinical_studies", force: :cascade do |t|
    t.string   "core_project_number"
    t.string   "clinical_trials_gov_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "exporter_file_id"
  end

  add_index "project_clinical_studies", ["core_project_number", "clinical_trials_gov_id"], name: "index_project_clinical_studies", unique: true, using: :btree
  add_index "project_clinical_studies", ["exporter_file_id"], name: "index_project_clinical_studies_on_exporter_file_id", using: :btree

  create_table "project_patents", force: :cascade do |t|
    t.string   "patent_id"
    t.string   "project_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "exporter_file_id"
  end

  add_index "project_patents", ["exporter_file_id"], name: "index_project_patents_on_exporter_file_id", using: :btree
  add_index "project_patents", ["patent_id", "project_id"], name: "index_project_patents", unique: true, using: :btree

  create_table "project_publications", force: :cascade do |t|
    t.integer  "pmid"
    t.string   "project_number"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "exporter_file_id"
  end

  add_index "project_publications", ["exporter_file_id"], name: "index_project_publications_on_exporter_file_id", using: :btree
  add_index "project_publications", ["pmid", "project_number"], name: "index_project_publications_on_pmid_and_project_number", unique: true, using: :btree
  add_index "project_publications", ["pmid"], name: "index_project_publications_on_pmid", using: :btree
  add_index "project_publications", ["project_number"], name: "index_project_publications_on_project_number", using: :btree

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
    t.integer  "exporter_file_id"
    t.string   "org_ipf_code"
  end

  add_index "projects", ["application_id"], name: "index_projects_on_application_id", unique: true, using: :btree
  add_index "projects", ["core_project_num"], name: "index_projects_on_core_project_num", using: :btree
  add_index "projects", ["exporter_file_id"], name: "index_projects_on_exporter_file_id", using: :btree
  add_index "projects", ["org_name"], name: "index_projects_on_org_name", using: :btree
  add_index "projects", ["program_officer_name"], name: "index_projects_on_program_officer_name", using: :btree

  create_table "publications", force: :cascade do |t|
    t.integer  "pmid"
    t.string   "pub_title"
    t.string   "country"
    t.string   "issn"
    t.string   "lang"
    t.string   "page_number"
    t.string   "pub_date"
    t.integer  "pub_year"
    t.string   "journal_title"
    t.string   "journal_title_abbr"
    t.integer  "journal_issue"
    t.integer  "journal_volume"
    t.string   "author_list"
    t.integer  "pmc_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "abstract"
    t.integer  "exporter_file_id"
  end

  add_index "publications", ["country"], name: "index_publications_on_country", using: :btree
  add_index "publications", ["exporter_file_id"], name: "index_publications_on_exporter_file_id", using: :btree
  add_index "publications", ["issn"], name: "index_publications_on_issn", using: :btree
  add_index "publications", ["journal_issue"], name: "index_publications_on_journal_issue", using: :btree
  add_index "publications", ["journal_volume"], name: "index_publications_on_journal_volume", using: :btree
  add_index "publications", ["lang"], name: "index_publications_on_lang", using: :btree
  add_index "publications", ["pmc_id"], name: "index_publications_on_pmc_id", using: :btree
  add_index "publications", ["pmid"], name: "index_publications_on_pmid", unique: true, using: :btree
  add_index "publications", ["pub_year"], name: "index_publications_on_pub_year", using: :btree

end

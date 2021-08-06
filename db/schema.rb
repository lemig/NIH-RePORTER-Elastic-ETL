# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_06_172122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abstracts", id: :serial, force: :cascade do |t|
    t.integer "application_id"
    t.text "abstract_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "exporter_file_id"
    t.index ["application_id"], name: "index_abstracts_on_application_id", unique: true
    t.index ["exporter_file_id"], name: "index_abstracts_on_exporter_file_id"
  end

  create_table "clinical_studies", id: :serial, force: :cascade do |t|
    t.string "clinical_trials_gov_id"
    t.text "study"
    t.string "study_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "exporter_file_id"
    t.index ["clinical_trials_gov_id"], name: "index_clinical_studies_on_clinical_trials_gov_id", unique: true
    t.index ["exporter_file_id"], name: "index_clinical_studies_on_exporter_file_id"
    t.index ["study_status"], name: "index_clinical_studies_on_study_status"
  end

  create_table "diseases", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_diseases_on_name"
  end

  create_table "exporter_files", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "month"
    t.integer "year"
    t.string "xml_path"
    t.string "csv_path"
    t.datetime "file_updated_at"
    t.boolean "processed", default: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "record_count"
    t.index ["file_updated_at"], name: "index_exporter_files_on_file_updated_at"
    t.index ["processed"], name: "index_exporter_files_on_processed"
    t.index ["type"], name: "index_exporter_files_on_type"
    t.index ["xml_path", "csv_path"], name: "index_exporter_files_on_xml_path_and_csv_path", unique: true
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.string "duns"
    t.string "ipf_code"
    t.string "name"
    t.string "address"
    t.string "zip"
    t.string "state"
    t.string "country"
    t.float "lat"
    t.float "lon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.index ["country"], name: "index_organizations_on_country"
    t.index ["duns", "name"], name: "index_organizations_on_duns_and_name", unique: true
    t.index ["duns"], name: "index_organizations_on_duns", unique: true
    t.index ["ipf_code"], name: "index_organizations_on_ipf_code"
  end

  create_table "organizations_projects", id: false, force: :cascade do |t|
    t.integer "organization_id", null: false
    t.integer "project_id", null: false
    t.index ["organization_id", "project_id"], name: "index_organizations_projects_on_organization_id_and_project_id", unique: true
    t.index ["project_id", "organization_id"], name: "index_organizations_projects_on_project_id_and_organization_id", unique: true
  end

  create_table "patents", id: :serial, force: :cascade do |t|
    t.string "patent_title"
    t.string "patent_org_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "patent_id"
    t.integer "exporter_file_id"
    t.index ["exporter_file_id"], name: "index_patents_on_exporter_file_id"
    t.index ["patent_id"], name: "index_patents_on_patent_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "pi_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_people_on_name"
    t.index ["pi_id", "name"], name: "index_people_on_pi_id_and_name", unique: true
    t.index ["pi_id"], name: "index_people_on_pi_id", unique: true
  end

  create_table "people_projects", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "project_id", null: false
    t.index ["person_id", "project_id"], name: "index_people_projects_on_person_id_and_project_id", unique: true
    t.index ["project_id", "person_id"], name: "index_people_projects_on_project_id_and_person_id", unique: true
  end

  create_table "people_publications", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "publication_id", null: false
    t.index ["person_id", "publication_id"], name: "index_people_publications_on_person_id_and_publication_id", unique: true
    t.index ["publication_id", "person_id"], name: "index_people_publications_on_publication_id_and_person_id", unique: true
  end

  create_table "project_clinical_studies", id: :serial, force: :cascade do |t|
    t.string "core_project_number"
    t.string "clinical_trials_gov_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "exporter_file_id"
    t.index ["core_project_number", "clinical_trials_gov_id"], name: "index_project_clinical_studies", unique: true
    t.index ["exporter_file_id"], name: "index_project_clinical_studies_on_exporter_file_id"
  end

  create_table "project_patents", id: :serial, force: :cascade do |t|
    t.string "patent_id"
    t.string "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "exporter_file_id"
    t.index ["exporter_file_id"], name: "index_project_patents_on_exporter_file_id"
    t.index ["patent_id", "project_id"], name: "index_project_patents", unique: true
  end

  create_table "project_publications", id: :serial, force: :cascade do |t|
    t.integer "pmid"
    t.string "project_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "exporter_file_id"
    t.index ["exporter_file_id"], name: "index_project_publications_on_exporter_file_id"
    t.index ["pmid", "project_number"], name: "index_project_publications_on_pmid_and_project_number", unique: true
    t.index ["pmid"], name: "index_project_publications_on_pmid"
    t.index ["project_number"], name: "index_project_publications_on_project_number"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.integer "application_id"
    t.string "activity"
    t.string "administering_ic"
    t.string "application_type"
    t.string "arra_funded"
    t.date "award_notice_date"
    t.date "budget_start"
    t.date "budget_end"
    t.string "cfda_code"
    t.string "core_project_num"
    t.string "ed_inst_type"
    t.string "foa_number"
    t.string "full_project_num"
    t.string "funding_i_cs"
    t.string "funding_mechanism"
    t.integer "fy"
    t.string "ic_name"
    t.string "nih_spending_cats"
    t.string "org_city"
    t.string "org_country"
    t.string "org_dept"
    t.string "org_district"
    t.string "org_duns"
    t.string "org_fips"
    t.string "org_name"
    t.string "org_state"
    t.string "org_zipcode"
    t.text "phr"
    t.text "pis"
    t.string "program_officer_name"
    t.date "project_start"
    t.date "project_end"
    t.text "project_termsx"
    t.string "project_title"
    t.string "serial_number"
    t.string "study_section"
    t.string "study_section_name"
    t.integer "subproject_id"
    t.string "support_year"
    t.string "suffix"
    t.integer "direct_cost_amt"
    t.integer "indirect_cost_amt"
    t.integer "total_cost"
    t.integer "total_cost_sub_project"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "exporter_file_id"
    t.string "org_ipf_code"
    t.string "terms", default: [], array: true
    t.index ["application_id"], name: "index_projects_on_application_id", unique: true
    t.index ["core_project_num"], name: "index_projects_on_core_project_num"
    t.index ["exporter_file_id"], name: "index_projects_on_exporter_file_id"
    t.index ["org_name"], name: "index_projects_on_org_name"
    t.index ["program_officer_name"], name: "index_projects_on_program_officer_name"
  end

  create_table "publications", id: :serial, force: :cascade do |t|
    t.integer "pmid"
    t.string "pub_title"
    t.string "country"
    t.string "issn"
    t.string "lang"
    t.string "page_number"
    t.string "pub_date"
    t.integer "pub_year"
    t.string "journal_title"
    t.string "journal_title_abbr"
    t.integer "journal_issue"
    t.integer "journal_volume"
    t.string "author_list"
    t.integer "pmc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "abstract"
    t.integer "exporter_file_id"
    t.index ["country"], name: "index_publications_on_country"
    t.index ["exporter_file_id"], name: "index_publications_on_exporter_file_id"
    t.index ["issn"], name: "index_publications_on_issn"
    t.index ["journal_issue"], name: "index_publications_on_journal_issue"
    t.index ["journal_volume"], name: "index_publications_on_journal_volume"
    t.index ["lang"], name: "index_publications_on_lang"
    t.index ["pmc_id"], name: "index_publications_on_pmc_id"
    t.index ["pmid"], name: "index_publications_on_pmid", unique: true
    t.index ["pub_year"], name: "index_publications_on_pub_year"
  end

end

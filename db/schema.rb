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

ActiveRecord::Schema.define(version: 20171003105012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exporter_files", force: :cascade do |t|
    t.string   "name"
    t.string   "month"
    t.integer  "year"
    t.string   "xml_url"
    t.string   "csv_url"
    t.datetime "file_updated_at"
    t.boolean  "processed",       default: false
    t.string   "type"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "exporter_files", ["file_updated_at"], name: "index_exporter_files_on_file_updated_at", using: :btree
  add_index "exporter_files", ["processed"], name: "index_exporter_files_on_processed", using: :btree
  add_index "exporter_files", ["type"], name: "index_exporter_files_on_type", using: :btree
  add_index "exporter_files", ["xml_url", "csv_url"], name: "index_exporter_files_on_xml_url_and_csv_url", unique: true, using: :btree

end

class CreatePublications < ActiveRecord::Migration
  def change
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
    end

    add_index "publications", ["country"], name: "index_publications_on_country", using: :btree
    add_index "publications", ["issn"], name: "index_publications_on_issn", using: :btree
    add_index "publications", ["journal_issue"], name: "index_publications_on_journal_issue", using: :btree
    add_index "publications", ["journal_volume"], name: "index_publications_on_journal_volume", using: :btree
    add_index "publications", ["lang"], name: "index_publications_on_lang", using: :btree
    add_index "publications", ["pmc_id"], name: "index_publications_on_pmc_id", using: :btree
    add_index "publications", ["pmid"], name: "index_publications_on_pmid", unique: true, using: :btree
    add_index "publications", ["pub_year"], name: "index_publications_on_pub_year", using: :btree
  end
end

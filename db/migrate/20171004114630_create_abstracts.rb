class CreateAbstracts < ActiveRecord::Migration
  def change
    create_table "abstracts", force: :cascade do |t|
      t.integer  "application_id"
      t.text     "abstract_text"
      t.datetime "created_at",     null: false
      t.datetime "updated_at",     null: false
    end

    add_index "abstracts", ["application_id"], name: "index_abstracts_on_application_id", unique: true, using: :btree
  end
end

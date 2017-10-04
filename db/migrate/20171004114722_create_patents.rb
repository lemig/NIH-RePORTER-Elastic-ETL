class CreatePatents < ActiveRecord::Migration
  def change
    create_table "patents", force: :cascade do |t|
      t.string   "patent_title"
      t.string   "patent_org_name"
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
      t.string   "patent_id",       index: true
    end
  end
end

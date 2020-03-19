class CreateDiseases < ActiveRecord::Migration
  def change
    create_table :diseases do |t|
      t.string :name, index: :unique

      t.timestamps null: false
    end
  end
end

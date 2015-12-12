class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :category_id
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end

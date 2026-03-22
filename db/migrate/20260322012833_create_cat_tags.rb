class CreateCatTags < ActiveRecord::Migration[8.0]
  def change
    create_table :cat_tags do |t|
      t.references :post, null: false, foreign_key: true
      t.references :cat, null: false, foreign_key: true

      t.timestamps
    end
  end
end

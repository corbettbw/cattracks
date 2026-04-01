class CreateCatFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :cat_follows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cat, null: false, foreign_key: true

      t.timestamps
    end
  end
end

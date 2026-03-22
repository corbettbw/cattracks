class CreateSightings < ActiveRecord::Migration[8.0]
  def change
    create_table :sightings do |t|
      t.references :cat, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :lat
      t.decimal :lng
      t.text :body

      t.timestamps
    end
  end
end

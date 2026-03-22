class CreateCareRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :care_relationships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cat, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end

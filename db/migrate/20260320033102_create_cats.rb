class CreateCats < ActiveRecord::Migration[8.0]
  def change
    create_table :cats do |t|
      t.string :name
      t.string :status
      t.text :bio
      t.integer :created_by, null: false

      t.timestamps
    end
    
    add_foreign_key :cats, :users, column: :created_by
    add_index :cats, :created_by
  end
end

class CreateUserTags < ActiveRecord::Migration[8.0]
  def change
    create_table :user_tags do |t|
      t.references :post, null: false, foreign_key: true
      t.integer :tagged_user

      t.timestamps
    end
    
    add_foreign_key :user_tags, :users, column: :tagged_user
    add_index :user_tags, :tagged_user
  end
end

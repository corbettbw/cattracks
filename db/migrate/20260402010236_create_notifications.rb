class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :actor_id, null: false
      t.references :notifiable, polymorphic: true, null: false
      t.integer :notification_type, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :actor_id
    add_index :notifications, :actor_id
  end
end
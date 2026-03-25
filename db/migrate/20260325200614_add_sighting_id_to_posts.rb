class AddSightingIdToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :sighting_id, :integer
  end
end

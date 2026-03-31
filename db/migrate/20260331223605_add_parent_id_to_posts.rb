class AddParentIdToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :parent_id, :integer
  end
end

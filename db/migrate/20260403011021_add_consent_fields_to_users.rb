class AddConsentFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :agreed_to_tos, :boolean
    add_column :users, :marketing_opt_in, :boolean
  end
end

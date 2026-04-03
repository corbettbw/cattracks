class AddLegalFieldsToProfiles < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :agreed_to_tos, :boolean
    add_column :profiles, :marketing_opt_in, :boolean
  end
end

class RemoveConsentFieldsFromProfiles < ActiveRecord::Migration[8.0]
  def change
    remove_column :profiles, :agreed_to_tos, :boolean
    remove_column :profiles, :marketing_opt_in, :boolean
  end
end

class AddZipCodeToSightings < ActiveRecord::Migration[8.0]
  def change
    add_column :sightings, :zip_code, :string
  end
end

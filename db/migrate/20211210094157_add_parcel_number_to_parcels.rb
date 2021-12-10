class AddParcelNumberToParcels < ActiveRecord::Migration[6.1]
  def change
    add_column :parcels, :parcel_number, :string
    add_index :parcels, :parcel_number, unique: true
  end
end

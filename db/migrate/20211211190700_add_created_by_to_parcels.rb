class AddCreatedByToParcels < ActiveRecord::Migration[6.1]
  def change
    add_column :parcels, :created_by, :bigint
  end
end

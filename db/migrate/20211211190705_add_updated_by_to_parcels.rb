class AddUpdatedByToParcels < ActiveRecord::Migration[6.1]
  def change
    add_column :parcels, :updated_by, :bigint
  end
end

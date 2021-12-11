class CreateParcelHistory < ActiveRecord::Migration[6.1]
  def change
    create_table :parcel_histories do |t|
      t.bigint :parcel_id, null: false
      t.string :status, null: false

      t.timestamps
    end
    add_index :parcel_histories, :parcel_id
  end
end

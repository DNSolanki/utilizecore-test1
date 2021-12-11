class AddUpdatedByToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :updated_by, :bigint
  end
end

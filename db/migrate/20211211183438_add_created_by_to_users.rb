class AddCreatedByToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :created_by, :bigint
  end
end

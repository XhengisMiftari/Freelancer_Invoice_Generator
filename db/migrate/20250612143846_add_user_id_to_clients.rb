class AddUserIdToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :user_id, :bigint, null: false
    add_foreign_key :clients, :users
    add_index :clients, :user_id
  end
end

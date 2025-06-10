class ChangePhoneNumberToStringInClientsAndUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :clients, :phone_number, :string
    change_column :users, :phone_number, :string
  end
end

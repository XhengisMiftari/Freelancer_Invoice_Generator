class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :address
      t.integer :phone_number
      t.string :company_name
      t.string :email

      t.timestamps
    end
  end
end

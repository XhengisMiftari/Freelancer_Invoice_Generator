class AddBalanceCentsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :balance_cents, :integer, default: 0, null: false
  end
end

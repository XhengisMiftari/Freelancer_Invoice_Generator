class AddCheckoutSessionIdToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :checkout_session_id, :string
  end
end

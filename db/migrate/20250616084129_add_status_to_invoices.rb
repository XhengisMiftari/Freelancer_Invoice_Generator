class AddStatusToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :status, :boolean
  end
end

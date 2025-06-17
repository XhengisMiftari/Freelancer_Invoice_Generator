class AddPriceToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_monetize :invoices, :price, currency: { present: false }
  end
end

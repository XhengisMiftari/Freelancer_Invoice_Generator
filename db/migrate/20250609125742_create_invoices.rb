class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.decimal :tax
      t.string :description
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end

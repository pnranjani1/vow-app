class AddColumnInvoiceFormatBills < ActiveRecord::Migration
  def change
    add_column :bills, :invoice_format, :string
  end
end

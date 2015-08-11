class RemoveColumnInvoiceNumberFormatInBills < ActiveRecord::Migration
  def change
    remove_column :bills, :invoice_number_format
    add_column :bills, :invoice_number_format, :boolean, :default => 1
  end
end

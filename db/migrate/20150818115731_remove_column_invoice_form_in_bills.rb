class RemoveColumnInvoiceFormInBills < ActiveRecord::Migration
  def change
    remove_column :bills, :instant_invoice_format
  end
end

class RemoveInvoiceFormatColumnFromBills < ActiveRecord::Migration
  def change
    remove_column :bills, :invoice_number_format
    add_column :bills, :invoice_number_format, :string, :dafault => "automatic"
  end
end

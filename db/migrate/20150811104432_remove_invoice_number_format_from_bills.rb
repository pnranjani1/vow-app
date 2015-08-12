class RemoveInvoiceNumberFormatFromBills < ActiveRecord::Migration
  def change
    #remove_column :bills, :invoice_number_formats
    add_column :bills, :record_number, :string
  end
end

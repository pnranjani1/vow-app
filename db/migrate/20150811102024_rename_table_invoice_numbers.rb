class RenameTableInvoiceNumbers < ActiveRecord::Migration
  def change
    rename_table :invoice_numbers, :invoice_number_records
  end
end

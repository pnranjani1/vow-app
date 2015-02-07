class ChangeColumnInvoiceNumberToStringInBills < ActiveRecord::Migration
  def change
    change_column :bills, :invoice_number, :string
  end
end

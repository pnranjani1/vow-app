class RemoveDefaultValueInvoiceFormatAuthusers < ActiveRecord::Migration
  def change
    remove_column :authusers, :invoice_format, :string
    add_column :authusers, :invoice_format, :string
  end
end

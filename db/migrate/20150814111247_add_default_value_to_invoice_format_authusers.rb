class AddDefaultValueToInvoiceFormatAuthusers < ActiveRecord::Migration
  def change
    change_column :authusers, :invoice_format, :string, :default => "automatic"
  end
end

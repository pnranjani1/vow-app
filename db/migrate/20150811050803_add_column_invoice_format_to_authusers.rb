class AddColumnInvoiceFormatToAuthusers < ActiveRecord::Migration
  def change
    add_column :authusers, :invoice_format, :string, :default => "automatic"
  end
end

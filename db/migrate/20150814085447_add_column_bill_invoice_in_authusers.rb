class AddColumnBillInvoiceInAuthusers < ActiveRecord::Migration
  def change
    add_column :authusers, :default_invoice, :string, :default => "automatic"
  end
end

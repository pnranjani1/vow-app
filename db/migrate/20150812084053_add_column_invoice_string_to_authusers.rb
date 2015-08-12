class AddColumnInvoiceStringToAuthusers < ActiveRecord::Migration
  def change
    add_column :authusers, :invoice_string, :string
  end
end

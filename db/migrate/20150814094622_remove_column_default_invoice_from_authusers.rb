class RemoveColumnDefaultInvoiceFromAuthusers < ActiveRecord::Migration
  def change
    remove_column :authusers, :default_invoice
  end
end

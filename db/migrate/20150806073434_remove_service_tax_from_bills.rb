class RemoveServiceTaxFromBills < ActiveRecord::Migration
  def change
    remove_column :bills, :service_tax_id
    add_column :line_items, :service_tax_id, :integer
  end
end

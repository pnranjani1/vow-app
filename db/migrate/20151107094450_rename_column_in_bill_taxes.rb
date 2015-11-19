class RenameColumnInBillTaxes < ActiveRecord::Migration
  def change
    rename_column :bill_taxes, :bill_id, :line_item_id
  end
end

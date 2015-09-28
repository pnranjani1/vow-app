class RemoveColumnTaxIdTaxTypeFromBills < ActiveRecord::Migration
  def change
    remove_column :bills, :tax_id
    remove_column :bills, :tax_type
  end
end

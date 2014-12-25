class AddTaxToBills < ActiveRecord::Migration
  def change
    add_column :bills, :tax, :float
    remove_column :bills, :tax_id
  end
end

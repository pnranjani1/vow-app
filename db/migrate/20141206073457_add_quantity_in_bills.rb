class AddQuantityInBills < ActiveRecord::Migration
  def change
    remove_column :bills, :quantity
    add_column :line_items, :quantity, :integer
  end
end

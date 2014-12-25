class RemoveQuantityPrice < ActiveRecord::Migration
  def change
    remove_column :line_items, :quantity
    remove_column :line_items, :price
  end
end

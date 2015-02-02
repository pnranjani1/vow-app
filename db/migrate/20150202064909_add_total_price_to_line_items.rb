class AddTotalPriceToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :total_item_price, :float
  end
end

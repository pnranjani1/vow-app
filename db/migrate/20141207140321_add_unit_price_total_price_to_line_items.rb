class AddUnitPriceTotalPriceToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :unit_price, :float
    add_column :line_items, :total_price, :float
    add_column :bills, :remarks, :text
  end
end

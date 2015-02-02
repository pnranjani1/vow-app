class AddTotalPriceToBills < ActiveRecord::Migration
  def change
    add_column :bills, :total_price, :float
  end
end

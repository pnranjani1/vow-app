class AddTotalBillPriceToBills < ActiveRecord::Migration
  def change
    add_column :bills, :total_bill_price, :float
    remove_column :line_items,  :product_price
  end
end

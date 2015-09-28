class AddColumnDiscountToBills < ActiveRecord::Migration
  def change
    add_column :bills, :discount, :float
  end
end

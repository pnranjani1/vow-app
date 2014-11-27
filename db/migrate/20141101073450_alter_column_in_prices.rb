class AlterColumnInPrices < ActiveRecord::Migration
  def change
    rename_column :prices, :price, :unit_price
  end
end

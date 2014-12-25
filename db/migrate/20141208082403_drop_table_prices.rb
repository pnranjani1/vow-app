class DropTablePrices < ActiveRecord::Migration
  def change
    drop_table :prices
    remove_column :usercategories, :tax_type, :string
    remove_column :usercategories, :tax_rate, :float
  end
end

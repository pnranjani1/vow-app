class DropTableProductsBills < ActiveRecord::Migration
  def change
    drop_table :products_bills
  end
end

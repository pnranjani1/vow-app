class AddColumnToBills < ActiveRecord::Migration
  def change
    add_column :bills, :price_id, :float
  end
end

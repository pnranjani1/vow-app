class AddGransTotalToBills < ActiveRecord::Migration
  def change
    add_column :bills, :grand_total, :float
  end
end

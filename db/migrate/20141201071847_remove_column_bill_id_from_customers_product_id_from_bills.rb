class RemoveColumnBillIdFromCustomersProductIdFromBills < ActiveRecord::Migration
  def change
    remove_column :customers, :bill_id, :integer
    remove_column :bills, :product_id, :integer
  end
end

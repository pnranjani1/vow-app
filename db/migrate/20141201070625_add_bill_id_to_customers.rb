class AddBillIdToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :bill_id, :integer
  end
end

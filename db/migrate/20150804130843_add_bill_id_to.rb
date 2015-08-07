class AddBillIdTo < ActiveRecord::Migration
  def change
    add_column :unregistered_customers, :bill_id, :integer
  end
end

class AddStateToUnregisteredCustomers < ActiveRecord::Migration
  def change
    add_column :unregistered_customers, :state, :string
  end
end

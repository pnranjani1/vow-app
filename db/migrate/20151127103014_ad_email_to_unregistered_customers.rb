class AdEmailToUnregisteredCustomers < ActiveRecord::Migration
  def change
    add_column :unregistered_customers, :email, :string
  end
end

class AddPincodeToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :pin_code, :string
  end
end

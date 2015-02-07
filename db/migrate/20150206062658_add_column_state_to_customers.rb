class AddColumnStateToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :state, :string
  end
end

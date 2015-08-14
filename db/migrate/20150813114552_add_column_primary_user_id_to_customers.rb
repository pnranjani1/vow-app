class AddColumnPrimaryUserIdToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :primary_user_id, :integer
  end
end

class RenameColumnAuthuserIdToUserIdInCustomers < ActiveRecord::Migration
  def change
    rename_column :customers, :authuser_id, :user_id
  end
end

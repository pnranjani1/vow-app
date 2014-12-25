class RenameUserIdToAuthuserIdInCustomers < ActiveRecord::Migration
  def change
    rename_column :customers, :user_id, :authuser_id
  end
end

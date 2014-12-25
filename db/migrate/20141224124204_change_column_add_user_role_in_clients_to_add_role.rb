class ChangeColumnAddUserRoleInClientsToAddRole < ActiveRecord::Migration
  def change
    rename_column :clients, :add_user_role, :add_role
  end
end
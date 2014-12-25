class AddColumnAddUserRoleToClients < ActiveRecord::Migration
  def change
    add_column :clients, :add_user_role, :boolean
  end
end

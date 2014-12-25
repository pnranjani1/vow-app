class AddColumnRoleUserToClients < ActiveRecord::Migration
  def change
    add_column :clients,  :role_user, :string
  end
end

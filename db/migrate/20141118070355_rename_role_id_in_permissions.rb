class RenameRoleIdInPermissions < ActiveRecord::Migration
  def change
    rename_column :permissions, :role_id, :m_role_id
  end
end

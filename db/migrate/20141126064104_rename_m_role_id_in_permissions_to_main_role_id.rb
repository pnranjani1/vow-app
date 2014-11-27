class RenameMRoleIdInPermissionsToMainRoleId < ActiveRecord::Migration
  def change
    rename_column :permissions, :m_role_id, :main_role_id
  end
end

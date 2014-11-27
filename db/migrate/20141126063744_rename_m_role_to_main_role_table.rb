class RenameMRoleToMainRoleTable < ActiveRecord::Migration
  def change
    rename_table :m_roles, :main_roles
  end
end

class RemoveColumnFromRoles < ActiveRecord::Migration
  def change
    remove_column :roles, :role_id
  end
end

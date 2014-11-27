class RemoveColumnRoleFromAuthusers < ActiveRecord::Migration
  def change
    remove_column :authusers, :role
  end
end

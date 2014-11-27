class AddTimestampsToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :created_at, :datetime
    add_column :permissions, :updated_at, :datetime
    rename_column :permissions, :roles_id, :role_id
    add_column :permissions, :id, :integer
  end
end

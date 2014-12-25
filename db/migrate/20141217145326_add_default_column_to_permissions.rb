class AddDefaultColumnToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :default, :boolean, default: false
    remove_column :authusers, :current_role
  end
end

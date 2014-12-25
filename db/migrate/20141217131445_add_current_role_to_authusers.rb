class AddCurrentRoleToAuthusers < ActiveRecord::Migration
  def change
    add_column :authusers, :current_role, :string
  end
end

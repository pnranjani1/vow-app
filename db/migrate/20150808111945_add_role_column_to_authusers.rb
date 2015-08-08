class AddRoleColumnToAuthusers < ActiveRecord::Migration
  def change
    add_column :authusers, :role, :string
  end
end

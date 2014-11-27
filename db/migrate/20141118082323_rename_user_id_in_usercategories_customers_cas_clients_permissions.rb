class RenameUserIdInUsercategoriesCustomersCasClientsPermissions < ActiveRecord::Migration
  def change
   # rename_column :usercategories, :user_id, :authuser_id
    rename_column :customers, :user_id, :authuser_id
    rename_column :cas, :user_id, :authuser_id
    rename_column :clients, :user_id, :authuser_id
    rename_column :permissions, :user_id, :authuser_id
  end
end

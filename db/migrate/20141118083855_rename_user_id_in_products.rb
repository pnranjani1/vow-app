class RenameUserIdInProducts < ActiveRecord::Migration
  def change
    rename_column :products, :user_id, :authuser_id
    rename_column :m_categories, :user_id, :authuser_id
  end
end

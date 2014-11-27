class RenameTableNamesRolesCategories < ActiveRecord::Migration
  def change
    rename_table :roles, :m_roles
    rename_table :categories, :m_categories
  end
end

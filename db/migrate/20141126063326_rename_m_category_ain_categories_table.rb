class RenameMCategoryAinCategoriesTable < ActiveRecord::Migration
  def change
    rename_table :m_categories, :main_categories
  end
end

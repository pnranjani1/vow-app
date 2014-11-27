class RenameCategoryNameTocommodityNameInMcategories < ActiveRecord::Migration
  def change
    rename_column :m_categories, :category_name, :commodity_name
  end
end

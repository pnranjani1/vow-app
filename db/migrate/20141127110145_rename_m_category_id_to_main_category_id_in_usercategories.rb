class RenameMCategoryIdToMainCategoryIdInUsercategories < ActiveRecord::Migration
  def change
    rename_column :usercategories, :m_category_id, :main_category_id
  end
end

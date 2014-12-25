class RenameCategoryIdToUsercategoryIdInProducts < ActiveRecord::Migration
  def change
    rename_column :products, :category_id, :usercategory_id
  end
end

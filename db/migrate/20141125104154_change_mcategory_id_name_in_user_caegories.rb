class ChangeMcategoryIdNameInUserCaegories < ActiveRecord::Migration
  def change
    rename_column :usercategories, :m_categoy_id, :m_category_id
  end
end

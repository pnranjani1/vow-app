class ChangeMcategoryIdNameInUserCaegories < ActiveRecord::Migration
  def change
    change_column :usercategories, :m_categoy_id, :m_category_id
  end
end

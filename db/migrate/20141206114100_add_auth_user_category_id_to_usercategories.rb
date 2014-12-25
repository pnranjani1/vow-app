class AddAuthUserCategoryIdToUsercategories < ActiveRecord::Migration
  def change
    add_column :usercategories, :auth_user_category_id, :integer
  end
end

class RemoveTableAuthUserCategories < ActiveRecord::Migration
  def change
    drop_table :auth_user_categories
  end
end

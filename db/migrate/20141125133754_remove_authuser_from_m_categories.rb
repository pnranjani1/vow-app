class RemoveAuthuserFromMCategories < ActiveRecord::Migration
  def change
    remove_column :m_categories, :authuser_id
  end
end

class AddIndexPermalinkToMainCategories < ActiveRecord::Migration
  def change
    add_index :main_categories, :permalink, unique: true
  end
end

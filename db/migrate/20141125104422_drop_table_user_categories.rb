class DropTableUserCategories < ActiveRecord::Migration
  def change
    drop_table :usercategories
    
  end
end

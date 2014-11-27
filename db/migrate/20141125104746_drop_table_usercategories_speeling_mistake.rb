class DropTableUsercategoriesSpeelingMistake < ActiveRecord::Migration
  def change
    drop_table :table_usercategories
    create_table :usercategories
  end
end

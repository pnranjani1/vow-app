class DropTableJcategory < ActiveRecord::Migration
  def change
    drop_table :j_categories
  end
end

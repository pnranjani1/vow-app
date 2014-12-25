class RemoveUsercategoryIdFromRaxes < ActiveRecord::Migration
  def change
    remove_column :taxes, :usercategory_id
  end
end

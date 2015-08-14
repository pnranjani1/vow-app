class AddColumnPrimaryUserIdToUsercategories < ActiveRecord::Migration
  def change
    add_column :usercategories, :primary_user_id, :integer
  end
end

class AddUserIdToUserprofiles < ActiveRecord::Migration
=begin
#Description: We don't use this table anymore , so commenting out !

  def change
    add_column :userprofiles, :user_id, :integer
  end
=end
end

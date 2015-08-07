class AddPrimaryUserIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :primary_user_id, :integer
  end
end

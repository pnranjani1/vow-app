class AddColumnPrimaryUserIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :primary_user_id, :integer
  end
end

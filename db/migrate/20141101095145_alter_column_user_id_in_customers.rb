class AlterColumnUserIdInCustomers < ActiveRecord::Migration
  def change
    change_column :customers, :user_id, :integer
  end
end

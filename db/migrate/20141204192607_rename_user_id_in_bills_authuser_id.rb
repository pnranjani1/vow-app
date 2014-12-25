class RenameUserIdInBillsAuthuserId < ActiveRecord::Migration
  def change
    rename_column :bills, :user_id, :authuser_id
  end
end

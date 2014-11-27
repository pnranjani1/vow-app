class DeleteColumnsInAdmin < ActiveRecord::Migration
  def change
    remove_column :admins, :tin_number
    remove_column :admins, :esugam_user_name
    remove_column :admins, :bank_account_number
    remove_column :admins, :ifsc_code
  end
end

class RemoveColumnsFromAdmin < ActiveRecord::Migration
  def change
    remove_column :admins, :name
    remove_column :admins, :email
    remove_column :admins, :phone_number
    remove_column :admins, :address
    remove_column :admins, :city
    end
end

class RemoveColumnsFromClients < ActiveRecord::Migration
  def change
    remove_column :clients, :name
    remove_column :clients, :email
    remove_column :clients, :address
    remove_column :clients, :city
    remove_column :clients, :membership_satrt_date
    remove_column :clients, :membership_end_date
    remove_column :clients, :membership_duration
    remove_column :clients, :membership_status
    add_column :clients, :esugam_username, :string
    add_column :clients, :esugam_password, :string
  end
end

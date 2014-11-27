class AddAdminIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :admin_id, :integer
  end
end

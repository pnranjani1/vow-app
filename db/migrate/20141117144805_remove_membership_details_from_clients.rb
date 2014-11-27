class RemoveMembershipDetailsFromClients < ActiveRecord::Migration
  def change
    remove_column :clients, :membership_start_date
  end
end

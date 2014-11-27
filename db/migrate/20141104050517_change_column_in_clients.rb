class ChangeColumnInClients < ActiveRecord::Migration
  def change
    rename_column :clients, :membershio_duration, :membership_duration
   end
end

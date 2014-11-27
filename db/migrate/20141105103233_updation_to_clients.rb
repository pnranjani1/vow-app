class UpdationToClients < ActiveRecord::Migration
  def change
    drop_table :clients
  end
end

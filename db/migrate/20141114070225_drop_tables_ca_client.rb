class DropTablesCaClient < ActiveRecord::Migration
  def change
    drop_table :cas
    drop_table :clients
  end
end

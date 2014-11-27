class RenameCasClientsTablenames < ActiveRecord::Migration
  def change
    rename_table :clients, :users
    rename_table :cas, :clients
  end
end

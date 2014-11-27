class RenameColumnCaIdInUsersTableToClientId < ActiveRecord::Migration
  def change
    rename_column :users, :ca_id, :client_id
  end
end

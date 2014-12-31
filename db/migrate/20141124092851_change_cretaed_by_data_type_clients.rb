class ChangeCretaedByDataTypeClients < ActiveRecord::Migration
=begin
Description: Moved the created_by column to the 20141114072255_create_clients.rb migration.
  def change
    change_column :clients, :created_by, 'integer USING CAST(created_by AS integer)'
  end
=end
end

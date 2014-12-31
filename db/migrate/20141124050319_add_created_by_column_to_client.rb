class AddCreatedByColumnToClient < ActiveRecord::Migration
=begin
    Description: Moved the created_by column to the 20141114072255_create_clients.rb migration.
  def change
    add_column :clients, :created_by, :string
  end
=end
end

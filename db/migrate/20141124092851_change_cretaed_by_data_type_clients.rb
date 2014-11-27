class ChangeCretaedByDataTypeClients < ActiveRecord::Migration
  def change
    change_column :clients, :created_by, :integer
  end
end

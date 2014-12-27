class ChangeCretaedByDataTypeClients < ActiveRecord::Migration
  def change
    change_column :clients, :created_by, 'integer USING CAST(created_by AS integer)'
  end
end

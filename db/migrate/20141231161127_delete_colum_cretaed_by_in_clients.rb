class DeleteColumCretaedByInClients < ActiveRecord::Migration
  def change
    remove_column :clients, :created_by
    add_column :clients, :created_by, :integer
  end
end

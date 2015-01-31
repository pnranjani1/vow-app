class AddColumnToClientsAndBillsTables < ActiveRecord::Migration
  def change
    add_column :clients, :approved, :boolean
    add_column :bills, :client_id, :integer
  end
end

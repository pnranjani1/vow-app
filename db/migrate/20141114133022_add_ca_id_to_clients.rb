class AddCaIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :ca_id, :integer
  end
end

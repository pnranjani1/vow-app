class AddColumnReferredByInClients < ActiveRecord::Migration
  def change
    add_column :clients, :referred_by, :string
  end
end

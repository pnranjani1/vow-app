class AddUserIdToClientCa < ActiveRecord::Migration
  def change
    add_column :clients, :user_id, :integer
    add_column :cas, :user_id, :integer
  end
end

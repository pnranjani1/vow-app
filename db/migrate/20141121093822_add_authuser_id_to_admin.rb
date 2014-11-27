class AddAuthuserIdToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :authuser_id, :integer
  end
end

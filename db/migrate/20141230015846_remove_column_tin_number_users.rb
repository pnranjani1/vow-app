class RemoveColumnTinNumberUsers < ActiveRecord::Migration
  def change
    remove_column :users, :tin_number
    add_column :users, :tin_number, :integer, :limit => 11
  end
end

class ChangeTinNumberTypeIntegerToString < ActiveRecord::Migration
  def change
    remove_column :users, :tin_number
    add_column :users, :tin_number, :string
  end
end

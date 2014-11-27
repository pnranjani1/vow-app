class RemoveColumnFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :membership_start_date
  end
end

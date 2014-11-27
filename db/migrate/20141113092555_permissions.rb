class Permissions < ActiveRecord::Migration
  def change
    create_table :permissions, :id => false do |t|
      t.integer :user_id
      t.integer :roles_id
    end
  end
end

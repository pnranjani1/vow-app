class AddColumn < ActiveRecord::Migration
  def change
    add_column :clients, :user_role, :boolean
  end
end

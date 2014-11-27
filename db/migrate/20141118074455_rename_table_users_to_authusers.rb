class RenameTableUsersToAuthusers < ActiveRecord::Migration
  def change
    rename_table :users, :authusers
  end
end

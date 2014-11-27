class RemoveAccountantsUserprofiles < ActiveRecord::Migration
  def change
    drop_table :accountants
    drop_table :userprofiles
  end
end

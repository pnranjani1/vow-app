class AddApprovedToAuthusers < ActiveRecord::Migration
  def change
  add_column :authusers, :approved, :boolean, :default => false
  add_index  :authusers, :approved
  end
end

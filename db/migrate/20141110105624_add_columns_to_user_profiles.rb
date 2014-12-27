class AddColumnsToUserProfiles < ActiveRecord::Migration
  def change
   
    add_column :userprofiles, :address, :string
    add_column :userprofiles, :city, :string
    change_column :userprofiles, :membership_status, 'boolean USING CAST(membership_status AS boolean)'
    add_column :userprofiles, :membership_duration, :integer
    
  end
end

class AddColumnsToUserProfiles < ActiveRecord::Migration

  # Description: As we are not using this userprofile table itself, so those migrations
  #are not valid anymore. SO, commented out.
=begin
  def change
    add_column :userprofiles, :address, :string
    add_column :userprofiles, :city, :string
    change_column :userprofiles, :membership_status, 'boolean USING CAST(membership_status AS boolean)'
    add_column :userprofiles, :membership_duration, :integer
  end
=end

end

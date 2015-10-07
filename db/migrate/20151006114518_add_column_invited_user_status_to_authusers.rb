class AddColumnInvitedUserStatusToAuthusers < ActiveRecord::Migration
  def change
    add_column :authusers, :invited_user_status, :boolean
  end
end

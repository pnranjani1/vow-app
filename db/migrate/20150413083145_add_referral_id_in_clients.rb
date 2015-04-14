class AddReferralIdInClients < ActiveRecord::Migration
  def change
    add_column :clients, :referral_id, :integer
  end
end

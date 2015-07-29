class AddColumnInReferralFor < ActiveRecord::Migration
  def change
    remove_column :referrals, :type_of_referral
    add_column :referrals, :referral_type_id, :integer
  end
end

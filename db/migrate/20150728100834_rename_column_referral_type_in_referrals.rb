class RenameColumnReferralTypeInReferrals < ActiveRecord::Migration
  def change
    rename_column :referrals, :referral_type, :type_of_referral
  end
end

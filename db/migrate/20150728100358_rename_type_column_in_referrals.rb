class RenameTypeColumnInReferrals < ActiveRecord::Migration
  def change
    rename_column :referrals, :type, :referral_type
  end
end

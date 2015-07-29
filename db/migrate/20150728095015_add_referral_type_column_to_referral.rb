class AddReferralTypeColumnToReferral < ActiveRecord::Migration
  def change
    add_column :referrals, :type, :string
    add_column :referrals, :pricing, :string
  end
end

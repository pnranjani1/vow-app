class ReferralType < ActiveRecord::Base
  
  has_many :referrals
  
  validates :referral_type, :pricing, presence: true
end

class Referral < ActiveRecord::Base
  
  validate :name, presence: true
  
  has_many :clients
  belongs_to :referral_type
  
  
end

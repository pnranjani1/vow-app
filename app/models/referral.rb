class Referral < ActiveRecord::Base
  
  validate :name, presence: true
  
  has_many :clients
  
  
end

class Referral < ActiveRecord::Base
  
  validate :name, :email, :address_line_1, :address_line_2, :state, :country, :mobile_number, presence: true
  
  has_many :clients
  
  
end

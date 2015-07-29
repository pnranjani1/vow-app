class Referral < ActiveRecord::Base
  
  validate :name, presence: true
  
  has_many :clients
  belongs_to :referral_type
  
  validates :name, :address_line_1, :address_line_2, :state, :country, :mobile_number, :email, :referral_type_id , presence: true
end

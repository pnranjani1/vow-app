class OtherChargesInformation < ActiveRecord::Base
  
  has_many :bill_other_charges
  has_many :bills, through: :bill_other_charges
  #has_many :bills
end

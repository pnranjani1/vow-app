class UnregisteredCustomer < ActiveRecord::Base
  belongs_to :bill
  belongs_to :authuser
  
 #validates :customer_name, :address, :city, :state , :presence => true, :allow_blank => true
  validates :customer_name, :address, :city, :state, :presence => true
  

end

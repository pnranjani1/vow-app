class UnregisteredCustomer < ActiveRecord::Base
  belongs_to :bills
  belongs_to :authuser
  
 validates :customer_name, :address, :city, :state , :presence => true, :allow_blank => true
end

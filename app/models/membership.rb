class Membership < ActiveRecord::Base
  belongs_to :authuser
  
  validates :phone_number, presence: true
validates :phone_number, numericality: {only_integer: true}
 validates :phone_number, length: { is: 10}
 # validates :authuser_id, presence: true
  
end

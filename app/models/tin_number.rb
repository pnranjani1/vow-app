class TinNumber < ActiveRecord::Base
  
  validates :state, :tin_number, presence: true
  validates :tin_number, length: { is: 11, message: "should be 11 digits"}
end

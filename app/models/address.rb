class Address < ActiveRecord::Base
  belongs_to :authuser
  
  validates :address_line_1, :city, :state, :country, presence: true
  
end

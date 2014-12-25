class Admin < ActiveRecord::Base
  
  belongs_to :authuser
  has_many :clients
 
end

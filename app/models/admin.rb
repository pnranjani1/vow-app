class Admin < ActiveRecord::Base
  
  belongs_to :authuser
  has_many :clients
  has_many :users
end

class User < ActiveRecord::Base
  
  belongs_to :authuser
  belongs_to :client
  has_many :usercategories, dependent: :destroy
  has_many :products
end

class User < ActiveRecord::Base
  
  #before_update :generate_client_id
  
  validates :tin_number, :esugam_username, :esugam_password, presence: true
  validates :tin_number, length: { is: 11}
 
  belongs_to :authuser
  belongs_to :client
  has_many :usercategories, dependent: :destroy
  has_many :products
  has_many :customers, dependent: :destroy
  has_many :taxes

 # def generate_client_id
#   self.client_id = self.authuser.invited_by_id
 # end

  
 end

class Usercategory < ActiveRecord::Base
  
  before_save :generate_commodity_name
  
  #has_many :taxes
  belongs_to :authuser
  belongs_to :main_category
  has_many :products
  belongs_to :auth_user_category
  
  
  def generate_commodity_name
    self.commodity_name = self.main_category.commodity_name
  end
  
  
  
  end

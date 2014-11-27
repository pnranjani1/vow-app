class MainCategory < ActiveRecord::Base
 # before_save :generate_permalink
  has_many :products
  has_many :usercategories
  has_many :authusers, through: :usercategories
 

  #def to_param
   # permalink
  #end

  
 # private
  
  #def generate_permalink
   # self.permalink = self.commodity_name.parameterize
  #end
  
end

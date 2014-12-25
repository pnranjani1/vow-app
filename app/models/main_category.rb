class MainCategory < ActiveRecord::Base
 # before_save :generate_permalink
  
  validates :commodity_name, :commodity_code, presence: true
  
  belongs_to :authuser
  
  has_many :products
  
  has_many :usercategories
  
  #accepts_nested_attributes_for :usercategories

  
  
  #def to_param
   # permalink
  #end

  
 # private
  
  #def generate_permalink
   # self.permalink = self.commodity_name.parameterize
  #end
  
end

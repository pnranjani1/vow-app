class Usercategory < ActiveRecord::Base
  has_many :taxes
  belongs_to :authuser
  belongs_to :main_category
  
  end

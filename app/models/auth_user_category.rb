class AuthUserCategory < ActiveRecord::Base
  belongs_to :authuser
  has_many :usercategories
  
  accepts_nested_attributes_for :usercategories, :allow_destroy => true
end

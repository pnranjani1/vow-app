class Product < ActiveRecord::Base
  before_save :generate_permalink
  belongs_to :authuser
  belongs_to :category
  
  
  def to_param
    permalink
  end
  
  private
  def generate_permalink
    self.permalink = self.product_name.parameterize
  end
  
end

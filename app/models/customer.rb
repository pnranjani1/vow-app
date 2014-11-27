class Customer < ActiveRecord::Base
  before_save :generate_permalink
  belongs_to :authuser
  
  def to_param
    permalink
  end
  
  private
  def generate_permalink
    self.permalink = self.name.parameterize
  end
  
end

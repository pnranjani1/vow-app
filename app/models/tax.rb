class Tax < ActiveRecord::Base
  before_save :tax_type_with_rate
  
  belongs_to :usercategory
  belongs_to :user
  belongs_to :authuser
  has_many :bills
  
  def tax_type_with_rate
    self.tax = "#{self.tax_type} #{self.tax_rate}"
  end
  
end

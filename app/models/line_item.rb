class LineItem < ActiveRecord::Base
  before_save :generate_total_price
  
  belongs_to :product
  belongs_to :bill

  validates :quantity, :unit_price, presence: true
  
  def generate_total_price
    self.total_price = self.quantity * self.unit_price
  end
  
    
end

class LineItem < ActiveRecord::Base
  before_save :generate_total_price
  
  belongs_to :product
  belongs_to :bill

  validates :quantity, :unit_price,  presence: true
  validates :product_id, presence: { :message => " - Item Name cannot be left blank"}
 # validates :product_id, uniqueness: {:message => "  -  Selected Product is already added"}, :if => Authuser.current
  
  def generate_total_price
    self.total_price = self.quantity * self.unit_price
  end
  
    
end

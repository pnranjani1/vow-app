class LineItem < ActiveRecord::Base
  before_save :generate_total_price
  
  belongs_to :product
  belongs_to :bill
  belongs_to :service_tax

  validates :quantity, :unit_price,  presence: true
  validates :quantity, numericality: true#{only_integer: true, message: "should be a number"}
  validates :product_id, presence: { :message => " - Item Name cannot be left blank"}
 # validates :product_id, uniqueness: {:message => "  -  Selected Product is already added"}, :if => Authuser.current
  
  def generate_total_price
    self.total_price = self.quantity * self.unit_price
  end
  
    
end

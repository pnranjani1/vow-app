class LineItem < ActiveRecord::Base
  before_save :generate_total_price
  before_save :generate_service_tax_amount, :if => :service_tax_rate
  before_save :generate_tax_rate, :if => :tax_id
  before_save :generate_tax_type, :if => :tax_id
  
  belongs_to :product
  belongs_to :bill
  
  belongs_to :tax
  

  validates :quantity, :unit_price,  presence: true
  validates :quantity, numericality: true#{only_integer: true, message: "should be a number"}
  validates :product_id, presence: { :message => " - Item Name cannot be left blank"}
 # validates :product_id, uniqueness: {:message => "  -  Selected Product is already added"}, :if => Authuser.current
  
  def generate_total_price
    self.total_price = self.quantity * self.unit_price
  end
  
  def generate_service_tax_amount
    self.service_tax_amount = (self.service_tax_rate/100) * self.total_price
  end
  
  def generate_tax_rate
    tax = Tax.where(:id => self.tax_id).first.tax_rate
    self.tax_rate = (self.total_price) * (tax/100)
  end
  
  
  def generate_tax_type
    tax = Tax.where(:id => self.tax_id).first
    self.tax_type = tax.tax_type
  end
end

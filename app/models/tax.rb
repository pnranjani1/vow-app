class Tax < ActiveRecord::Base
  #before_save :tax_type_with_rate
  before_save :tax_name_upcase
  
  belongs_to :usercategory
  belongs_to :user
  belongs_to :authuser
#  has_many :bills
  #has_one :line_item
  
  has_many :bill_taxes
  has_many :line_items, through: :bill_taxes
  #validates :tax_type, :tax_rate, presence: true
  validates :tax_name, :tax_type, :tax_on_tax,  presence: true
  
 # scope :all_taxes, -> (type) { where(tax_type: type) }
  
  
  def tax_name_upcase
    self.tax_name = self.tax_name.upcase
  end
  
  def tax_type_with_rate
    self.tax = "#{self.tax_type} #{self.tax_rate}"
  end
  
end

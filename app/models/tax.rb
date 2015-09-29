class Tax < ActiveRecord::Base
  before_save :tax_type_with_rate
  
  belongs_to :usercategory
  belongs_to :user
  belongs_to :authuser
#  has_many :bills
  has_one :line_item
  validates :tax_type, :tax_rate, presence: true
  
  scope :all_taxes, -> (type) { where(tax_type: type) }
  
  def tax_type_with_rate
    self.tax = "#{self.tax_type} #{self.tax_rate}"
  end
  
end

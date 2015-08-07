class ServiceTax < ActiveRecord::Base
  
  validates :service_tax_name, :service_tax_rate, presence: true
  
  has_many :line_items
end

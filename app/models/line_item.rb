class LineItem < ActiveRecord::Base
  before_save :generate_total_price
  before_save :generate_service_tax_amount, :if => :service_tax_rate
 # before_save :generate_tax_rate, :if => :tax_id
 # before_save :generate_tax_type, :if => :tax_id
  #before_save :generate_tax_type
  
  belongs_to :product
  belongs_to :bill
  
  has_many :bill_taxes
  has_many :taxes, through: :bill_taxes
  
  validates :quantity, :unit_price,  presence: true
  validates :quantity, numericality: true#{only_integer: true, message: "should be a number"}
  validates :product_id, presence: { :message => " - Item Name cannot be left blank"}
 # validates :product_id, uniqueness: {:message => "  -  Selected Product is already added"}, :if => Authuser.current
  
  accepts_nested_attributes_for :bill_taxes,  :allow_destroy => true, :reject_if => :all_blank
  
  def generate_total_price
    self.total_price = self.quantity * self.unit_price
  end
  

  
  def generate_service_tax_amount
    self.service_tax_amount = (self.service_tax_rate/100) * self.total_price
  end
  
  def generate_tax_rate
    
    #tax = Tax.where(:id => self.tax_id).first.tax_rate
    #self.tax_rate = (self.total_price) * (tax/100)
  end
  
  
  def generate_tax_type
    if self.bill_taxes.present?
      tax = BillTax.where(:line_id_id => self.id)
     # taxes = tax.where('tax_name = ?', "VAT" OR "CST")
      #taxes = taxes.where.not(:tax_name => "CST")
      taxes.each do |tax|
        self.tax_type = tax.tax_name
        self.tax_rate = tax.tax_rate
      end
    end
  end
  
  
  
    #  billtaxes = BillTax.where(:line_item_id => self.id)
     # taxname = billtaxes.pluck(:tax_name)
     # if taxname.include? "VAT"
     #   self.update_attribute(:tax_type,  "VAT")
     # elsif taxname.include? "CST"
      ##  self.update_attribute(:tax_type ,"CST")
      #else
      #  self.update_attribute(:tax_type, "NA")
      #end
      
      
      #tax = self.bill_taxes.pluck(:tax_name)
      #if tax.include? "VAT"
#        self.tax_type = "VAT"
#      elsif tax.include? "CST"
#        self.tax_type = "CST"
#      else
 #       self.tax_type = "NA"
    #end
   # tax = Tax.where(:id => self.tax_id).first
#    self.tax_type = tax.tax_type
    
  
  
end

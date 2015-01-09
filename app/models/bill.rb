class Bill < ActiveRecord::Base
  
 # before_create :generate_invoice_number
  before_save :generate_grand_total
  before_save :generate_tax_type
  
  has_many :line_items 
  has_many :products, through: :line_items
  
  belongs_to :customer
  belongs_to :authuser
  
  belongs_to :tax
  
  validates :invoice_number, :bill_date, :tax_id, presence: true
  validates :invoice_number, :uniqueness => true
  validate :past_date
  validates :line_items, presence: true
 
  
  accepts_nested_attributes_for :line_items
  
#  def generate_invoice_number
 #   if Bill.last.invoice_number.nil?
  #    self.invoice_number = 1000
   # else 
    #  self.invoice_number = Bill.last.invoice_number + 1
   # end
  #end
 
  #def self.last_invoice_number_used
   # return last.invoice_number unless last.nil?
    # return 1000
#end

 # def self.next_invoice_number_to_use
  #  last_invoice_number_used+1
#end
  
    def past_date
      if self.bill_date < Date.today
        errors.add(:bill_date, 'Entered Bill Date is in the past')
      end
   end
  
  
  def generate_grand_total
    tax_amount = self.tax.tax_rate * 0.01
    total_amount = self.total_bill_price.to_f + self.other_charges.to_f
    total_tax = tax_amount * total_amount
    self.grand_total = total_amount.to_f + total_tax.to_f
  end
  
  
  def generate_tax_type
    self.tax_type  = self.tax.tax_type
  end
  
  
  
    def self.to_csv
    CSV.generate do |csv|
      csv << ["Invoice Number", "Bill Date", "Customer", "Tin Number",  "Total Price"]
      all.each do |bill|
     #  bill.line_items.each do|a|
      #   product = a.product.product_name
       #end
       #product = (a.product.product_name)
        csv << [bill.invoice_number, bill.bill_date.strftime("%b %d %Y"), bill.customer.name, bill.customer.tin_number, bill.total_bill_price]
        end
    end
  end




end

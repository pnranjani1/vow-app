class Customer < ActiveRecord::Base
 # before_save :generate_permalink
 # belongs_to :authuser
  belongs_to :user
  has_many :bills
  
  
  validates :name, :email, :tin_number, :phone_number, :address, :city, presence: true
   validates :tin_number, length: { is: 11}
  validates :phone_number, length: { is: 10}
  validates :phone_number, numericality: {only_integer: true}
  validates :email, confirmation: true
  validates_format_of :email, {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => "Doesn't look like an email address"}
  validates :email, uniqueness: {case_sensitive: false}
  
 
 # def to_param
  #  permalink
  #end
  
 # private
 # def generate_permalink
  #  self.permalink = self.name.parameterize
 # end
  
   def self.import(file, current_authuser)
     
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      customer = Customer.find_by_email(row["Email"]) || Customer.new
     # product.attributes = row.to_hash.slice('product_name', 'units', 'usercategory_id')
      
        customer.name = row["Customer Name"].to_s
        customer.email = row["Email"]
        customer.tin_number = row["Tin Number"].to_i
        customer.phone_number = row["Phone Number"].to_i
        customer.address = row["Address"]
        customer.city = row["City"]
        customer.authuser_id = current_authuser
         customer.save!
         
    end
   end
      

def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when ".csv" then Csv.new(file.path, nil, :ignore)
  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
  end
  
   end
  
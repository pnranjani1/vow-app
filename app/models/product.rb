class Product < ActiveRecord::Base
  #before_save :generate_permalink
    
  validates :units, presence: true
  validates :product_name, presence: {:message => " - Product Name can't' be blank"}
  validates :usercategory_id, presence: {:message => " - Select Commodity"}
 # validates :product_name , uniqueness: {:message => " - Selected Product is already added"}, :if => Authuser.current
  #validates_associated :usercategories
  
  belongs_to :authuser
  belongs_to :usercategory
  
  has_one :price
  
  has_many :line_items
  has_many :bills, through: :line_items
  
  
  accepts_nested_attributes_for :price
  
 # def to_param
  #  permalink
 # end
  
 # private
 # def generate_permalink
 #   self.permalink = self.product_name.parameterize
 # end
  
  def self.import(file, current_authuser)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = Product.find_by_product_name(row["Product Name"]) || Product.new
     # product.attributes = row.to_hash.slice('product_name', 'units', 'usercategory_id')
      product.authuser_id = current_authuser
     product.product_name = row["Product Name"]
        product.units = row["Units"]
      #Usercategory.where(product.usercategory_id
      product.usercategory_id = row["UserCategory ID"]
      product.save!
      end
        #commodity = Usercategory.where(usercategory_id: row["Commodity"].first)    
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

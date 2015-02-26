class MainCategory < ActiveRecord::Base
 # before_save :generate_permalink
  
  validates :commodity_name, :commodity_code, presence: true
  
  belongs_to :authuser
  
  has_many :products
  
  has_many :usercategories
  
  #accepts_nested_attributes_for :usercategories

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      category = MainCategory.find_by_commodity_name(row["Commodity Name"]) || MainCategory.new
     # product.attributes = row.to_hash.slice('product_name', 'units', 'usercategory_id')
      category.commodity_name = row["Commodity Name"]
      category.commodity_code = row["Commodity Code"]
      #Usercategory.where(product.usercategory_id
      category.sub_commodity_code = row["Sub Commodity Code"]
      category.save!
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

  
  #def to_param
   # permalink
  #end

  
 # private
  
  #def generate_permalink
   # self.permalink = self.commodity_name.parameterize
  #end
  
end

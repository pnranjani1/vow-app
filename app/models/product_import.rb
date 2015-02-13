class ProductImport
# switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_products.map(&:valid?).all?
      imported_products.each(&:save!)
      true
    else
      imported_products.each_with_index do |product, index|
        product.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_products
    @imported_products ||= load_imported_products
  end

  def load_imported_products
    spreadsheet = open_spreadsheet(file, current_authuser)
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
    
 
  def open_spreadsheet
    case File.extname(file.original_filename)
  when ".csv" then Csv.new(file.path, nil, :ignore)
  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
end

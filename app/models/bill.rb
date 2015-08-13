class Bill < ActiveRecord::Base
  
  before_save :generate_invoice_format  
  after_create :invoke_invoice_record
  after_create  :update_invoice_number
  
  
 #before_save :generate_invoice_record
  
  before_save :generate_grand_total
  before_save :generate_tax_type
  
  belongs_to :other_charges_information
  
  has_many :line_items 
  has_many :products, through: :line_items
  
  belongs_to :customer
  has_many :unregistered_customers
  belongs_to :authuser
  
  belongs_to :tax
  has_one :invoice_record
 
 
  
  validates  :bill_date, :tax_id, presence: true
  # CValidation for invoice number for manual and automated invoice numbers
  #validates :invoice_number, presence: true, :if => :manual_invoice
 

 # validates :invoice_number, :uniqueness => {:scope => :authuser_id}
  validate :past_date
 
 # validates :vechicle_number, length: {is: 12}
  #validates :gc_lr_number, length: { is: 12}
  validates :customer_id, presence: true
  validates :line_items, presence: true
#  validates :line_items, presence: true
 # validates :line_items , uniqueness: {:scope => :product_id, :message => "Selected Product is already added to the bill"}
  #validates :line_items, uniqueness: {:message => "Selected Item is already added in the bill"}, :if => Authuser.current
  
  accepts_nested_attributes_for :line_items, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :unregistered_customers
  
  
  def generate_invoice_format
    if Authuser.current.main_roles.first.role_name != "secondary_user"
      self.invoice_format = Authuser.current.invoice_format    
    else
      primary_user_id = Authuser.current.invited_by_id
      user = Authuser.where(:id => primary_user_id).first
      self.invoice_format = user.invoice_format
    end
  end
  
   
  def invoke_invoice_record
     user = Authuser.current
    #for primary user
    if user.main_roles.first.role_name != "secondary_user"
      bill_ids = InvoiceRecord.all.pluck(:bill_id)
      last_bill = Bill.where(:authuser_id => user.id).last
      if user.invoice_format == "automatic" 
         if user.invoice_records.blank?
            self.build_invoice_record
            self.invoice_record.number = "001"
            self.invoice_record.authuser_id = self.authuser.id
            self.invoice_record.bill_id = self.id
            self.update_attribute(:record_number, "001")
         elsif (user.invoice_format == "automatic") && (user.invoice_records.present?)
            bill_id = Bill.where(:authuser_id => user.id).last.id
            invoice = InvoiceRecord.where(:authuser_id => user.id).last
            number_updated = invoice.number.to_i + 1
            invoice.update_attribute(:number, number_updated)
            invoice.update_attribute(:authuser_id , user.id)
            invoice.update_attribute(:bill_id, self.id)
            self.update_attribute(:record_number, number_updated)
         end
      end
      #for secondary user
    else
      secondary_user = Authuser.current
      primary_user_id = Authuser.current.invited_by_id
      user = Authuser.where(:id => primary_user_id).first
       bill_ids = InvoiceRecord.all.pluck(:bill_id)
      last_bill = Bill.where(:authuser_id => user.id).last
      if (user.invoice_format == "automatic")
         if user.invoice_records.blank?
           self.build_invoice_record
           self.invoice_record.number = "001"
           self.invoice_record.authuser_id = self.authuser.id
           self.invoice_record.bill_id = self.id
           self.record_number = "001"
         elsif (user.invoice_format == "automatic") &&  user.invoice_records.present?
            bill_id = Bill.where(:authuser_id => user.id).last.id
            invoice = InvoiceRecord.where(:authuser_id => user.id).last
            number_updated = invoice.number.to_i + 1
            invoice.update_attribute(:number, number_updated)
            invoice.update_attribute(:authuser_id , user.id)
            invoice.update_attribute(:bill_id, self.id)
            self.update_attribute(:record_number, number_updated)
         end
      end
    end
  end
  
  def update_invoice_number
    if Authuser.current.main_roles.first.role_name != "secondary_user" 
      user = Authuser.current
         if user.invoice_format == "automatic" 
           bill_id = Bill.where('authuser_id =? AND invoice_format =? ', user.id, "automatic").last.id
           number_invoice_record = InvoiceRecord.where(:bill_id => bill_id).first.number
           if user.invoice_string.present?
             number = (number_invoice_record + " " + user.invoice_string)
             self.update_attribute(:invoice_number, number )
           else
             number = number_invoice_record
           self.update_attribute(:invoice_number, number )
           end 
         end
    elsif Authuser.current.main_roles.first.role_name == "secondary_user" 
      primary_user_id = Authuser.current.invited_by_id
      user = Authuser.where(:id => primary_user_id).first
        if user.invoice_format == "automatic" 
          bill_id = Bill.where('primary_user_id =? AND invoice_format =? ', user.id, "automatic").last.id
          number_invoice_record = InvoiceRecord.where(:bill_id => bill_id).first.number
          if user.invoice_string.present?
             number = (number_invoice_record + " " + user.invoice_string)
            self.update_attribute(:invoice_number, number )
           else
             number = number_invoice_record
           self.update_attribute(:invoice_number, number )
           end 
          
         end 
    end
  end
       
       
       
        
  
  def manual_invoice
    user = Authuser.current
    user.invoice_format == "manual"      
  end
     
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
       # bill.line_items.each do|a|
       # product = a.product.product_name
       #end
       #product = (a.product.product_name)
         csv << [
           bill.invoice_number, 
           bill.bill_date.strftime("%b %d %Y"), 
           bill.customer.name,
           bill.customer.tin_number, 
           bill.total_bill_price
         ]
      end
    end
  end
  
  def get_esugan_number
    @bill = self 
    @tax_type = @bill.tax.tax_type
    @invoice_number = @bill.invoice_number
    @invoice_date = @bill.bill_date
    
    
    # customer name and tin number for URD 
    urd_values = ["Others" ,"Other" ,"others", "other"]
    if urd_values.include? @bill.customer.name
      urd = UnregisteredCustomer.where(:bill_id => @bill.id).first
      @customer_city = urd.city
      @customer_tin_number = TinNumber.where(:state => urd.state).pluck(:tin_number).first
    else
      @customer_city = @bill.customer.city
      @customer_tin_number = @bill.customer.tin_number
    end
    @customer_name_address = @bill.customer.name + @bill.customer.city
    @customer_name = @bill.customer.name
    @user_city = @bill.authuser.address.city
    #@bill_product =  @bill.line_items.first.product.product_name
    @product_name =  @bill.line_items.first.product.product_name
    @commodity_name =  @bill.products.first.usercategory.main_category.commodity_name
    @quantity_units = " "+ @bill.line_items.first.quantity.to_s + " " +@bill.line_items.first.product.units
    @other_value = 0
   
    @total_amount = @bill.total_bill_price
    if @bill.other_charges_information_id != nil && @bill.other_charges != nil
      @total_amount += @bill.other_charges
    end
    
    tax_amount = @bill.tax.tax_rate * 0.01
    @total_tax = tax_amount * @total_amount
    @total_tax = @total_tax.round(2)
    @grand_total = @total_amount + @total_tax
    @grand_total = @grand_total.round(2)
    
    begin
      browser = Watir::Browser.new :phantomjs
      browser.goto "http://sugam.kar.nic.in/"
     
      browser.text_field(:id, "UserName").set(@bill.authuser.users.first.esugam_username)
      browser.text_field(:id, "Password").set(@bill.authuser.users.first.esugam_password)
      browser.button(:value,"Login").click
     
      if browser.text.include? "Login Failed"
        self.update_attributes(error_message: "Login Failed. Check your VAT website credentials")
        browser.close       
      else
            
      sleep 10
      browser.link(:id, "LinkButton1").click
    
      
      browser.text_field(:id, "ctl00_MasterContent_txtFromAddrs").set(@user_city)
      browser.text_field(:id, "ctl00_MasterContent_txtToAddrs").set(@customer_city)
      browser.text_field(:id, "ctl00_MasterContent_txt_commodityname").set(@product_name)
      if browser.select_list(:id, "ctl00_MasterContent_ddl_commoditycode").include? @commodity_name
         browser.select_list(:id, "ctl00_MasterContent_ddl_commoditycode").select(@commodity_name)
         browser.text_field(:id, "ctl00_MasterContent_txtQuantity").set(@quantity_units)
         browser.send_keys :tab
         browser.text_field(:id, "ctl00_MasterContent_txtNetValue").set(@total_amount)
         browser.send_keys :enter
         browser.send_keys :tab
         browser.text_field(:id, "ctl00_MasterContent_txtVatTaxValue").set(@total_tax)
         browser.text_field(:id, "ctl00_MasterContent_txtOthVal").set(@other_value)
         sleep 5
      
          if @tax_type == "CST"
            browser.radio(:id, "ctl00_MasterContent_rdoStatCat_1").set
            sleep 5
            browser.text_field(:id, "ctl00_MasterContent_txtTIN").set(@customer_tin_number.to_i)
            browser.send_keys :tab   
            if browser.text_field(:id, "ctl00_MasterContent_txtNameAddrs").enabled?
               browser.text_field(:id, "ctl00_MasterContent_txtNameAddrs").set(@customer_name)
            else
              sleep 5
              browser.text_field(:id, "ctl00_MasterContent_txtNameAddrs").set(@customer_name)
            end
            browser.send_keys :tab
          end
    
        # check if vat and urd
         
           if (@tax_type == "VAT") && (@customer_tin_number[2..-1] == "000000000")
              browser.text_field(:id, "ctl00_MasterContent_txtTIN").set(@customer_tin_number.to_i)
               browser.send_keys :tab
               sleep 5
               browser.text_field(:id, "ctl00_MasterContent_txtNameAddrs").set(@customer_name)
               browser.send_keys :tab
           end
        
        
        if @tax_type == "VAT"
          browser.text_field(:id, "ctl00_MasterContent_txtTIN").set(@customer_tin_number.to_i)
          browser.send_keys :tab
        end
        
        sleep 5 
        browser.text_field(:id, "ctl00_MasterContent_txtInvoiceNO").set(@bill.invoice_number)
        if browser.button(:id, "ctl00_MasterContent_btn_savecumsubmit").enabled?
            browser.button(:value,"SAVE AND SUBMIT").click
            page_html = Nokogiri::HTML.parse(browser.html)
            textual = page_html.search('//text()').map(&:text).delete_if{|x| x !~ /\w/}
            esugam = textual.fetch(7)
      
            if esugam.include? "Prop/Comp. Name: "
              file = File.new("app/assets/images/vat-error.png", "a+")
              browser.screenshot.save file
              self.update_attributes(error_message: file.to_s)
              logger.error "esugam not generated due to incomplete form submission"
            else
              self.update_attributes(esugam: esugam)
            end
            browser.button(:value,"Exit").click
            browser.link(:id, "link_signout").click
            browser.close
            return esugam
        else
          file = File.new("app/assets/images/vat-error.png", "a+")
          browser.screenshot.save file
          self.update_attributes(error_message: file.to_s)
        end
      else # if commodity is not in list else
        self.update_attributes(error_message: "Selected Commodity is not added in VAT Site")
        browser.close
      end # commodity not in list end
      end # login end
    end # begin end
  end # def end
 

end # class end



 
  
  
  
 # def customer
  #  self.customer.name == "Others" or "Other" or "others" or "other"      
  #end
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
  
  
 
  
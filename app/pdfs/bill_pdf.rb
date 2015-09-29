class BillPdf < Prawn::Document
  require 'prawn/table'
  require "open-uri"
  include ActionView::Helpers::NumberHelper
  
  
   def initialize(bill)
    super()
     @bill = bill
     @user = Authuser.find(@bill.authuser_id)
     stroke_bounds

     bill_title
     bill_user
     logo(@user)
     bill_customer
     bill_line
     bill_transport
     bill_products
     bill_table
     table_price_list
     authority
     terms_and_conditions
     #footer
     stroke_bounds 
   end


 # :margin => [10, 20, 30, 40]
      
   def bill_title    
    # font "Times-Roman"
     font 'Helvetica'
      draw_text "INVOICE", :at => [225,700],size: 16
      #if @bill.bill_date == nil
      # @bill.bill_date = Date.today
     #end
     bounding_box([320, 680], :width => 300) do
       text "Invoice Number   : #{@bill.invoice_number}" ,size:9, :inline_format => true, :leading => 3
      text "Invoice Date         : #{@bill.bill_date.strftime("%b %d, %Y")}" ,size:9, :inline_format => true
    end
  
    bounding_box([8, 650], :width => 300) do
      if @bill.esugam == nil
        text "e-Sugam Number: NA", :inline_format => true, size: 9
      else
        text "e-Sugam Number: #{@bill.esugam}", :inline_format=> true, size: 9
      end
    end
   end
  
   def bill_user   
     draw_text "Supplier", :at => [8, 630], size: 9
      bounding_box([8,620],:width =>250) do
        if @user.main_roles.first.role_name == "user"
          text "#{@bill.authuser.users.first.company.titleize}",size: 10, :style => :bold, :leading => 3
        elsif @user.main_roles.first.role_name  == "secondary_user"
          primary_user_id = @user.invited_by_id
          text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 10, :style => :bold, :leading => 3
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company.titleize}",size: 10, :style => :bold, :leading => 3
        end 
        # Get the address details of user for secondary user bill
        role_name = @user.main_roles.pluck(:role_name)
        unless role_name.include? "secondary_user"
        
          text "Address               :    #{@bill.authuser.address.address_line_1.capitalize}, " + "#{@bill.authuser.address.address_line_2}, " + "#{@bill.authuser.address.address_line_3}" , :inline_format => true, size: 9, :leading => 3
          text "City                      :    #{@bill.authuser.address.city.capitalize}", :inline_format => true, size: 9, :leading => 3
        #text "Country :#{@bill.authuser.address.country}"
          text "Phone Number    :   #{@bill.authuser.membership.phone_number}", :inline_format => true, size: 9, :leading => 3
          text " Tin Number         :   #{@bill.authuser.users.first.tin_number}", :inline_format => true, size: 9
        else
          primary_user_id = @bill.authuser.invited_by_id
          text "<b>Address               :</b>    #{Authuser.find(primary_user_id).address.address_line_1.capitalize}, " + "#{Authuser.find(primary_user_id).address.address_line_2}, " + "#{Authuser.find(primary_user_id).address.address_line_3}" , :inline_format => true, size: 9, :leading => 3
          text "<b>City                     :</b>    #{Authuser.find(primary_user_id).address.city.capitalize}", :inline_format => true, size: 9, :leading => 3
        #text "Country :#{@bill.authuser.address.country}"
          text "<b>Phone Number   :</b>   #{Authuser.find(primary_user_id).membership.phone_number}", :inline_format => true, size: 9, :leading => 3
          text "<b>Tin Number        :</b>   #{Authuser.find(primary_user_id).users.first.tin_number}", :inline_format => true, size: 9
        end
      end
   end

   def logo(user)
      role_name = @user.main_roles.pluck(:role_name)
      if role_name.include? "user"
       if @user.image.present?
         image open(@user.image_url), height: 50, width: 90, crop: "fit", :at => [10,710]
       end
      elsif @user.main_roles.first.role_name == "secondary_user"
        primary_user_id = @user.invited_by_id
        image open(Authuser.find(primary_user_id).image_url), height: 50, width: 90, crop: "fit", :at => [10,710]
      end
   end
        # gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        # size = 50
        #gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}?s=#{size}"+".jpg"
        #image open(gravatar_url), :at => [10,710]
   
     
  
   def bill_customer
     draw_text "Buyer", :at => [320, 630], size: 9
      urd_values = ["others", "other", "Others", "Other"]
      if urd_values.include? @bill.customer.name 
        customer = UnregisteredCustomer.where(:bill_id => @bill.id).first
        @bill.customer.name = customer.customer_name
        @bill.customer.address = customer.address
        @bill.customer.city = customer.city
        @bill.customer.phone_number = customer.phone_number
        state = customer.state
        tin = TinNumber.where(:state => state).first
        @bill.customer.tin_number = tin.tin_number
        
      else
        @bill.customer = @bill.customer
      end
         
      bounding_box([320, 620],:width => 220) do
        text "#{@bill.customer.name.titleize}", size:10, :style => :bold, :leading => 2
        text "Address               :   #{@bill.customer.address.capitalize}" , :inline_format => true, size: 9, :leading => 3 
        text "City                      :   #{@bill.customer.city.capitalize}", size: 9, :inline_format => true, :leading => 3
       # text "<b>PinCode               :</b>   #{@bill.customer.pin_code}", size: 11, :inline_format => true, :leading => 3
        text "Phone  Number   :  #{@bill.customer.phone_number}", size: 9, :inline_format => true, :leading => 3
        text "Tin  Number        :  #{@bill.customer.tin_number}", size: 9, :inline_format => true
      end
   end
     
   def bill_line 
      move_down 12
      stroke_horizontal_rule
   end
      
       
   def bill_transport   
      bounding_box([3,520], :width => 300) do
          if @bill.transporter_name == ""
            text "Goods Through : NA" , size: 9, :inline_format => true
          else
            text "Goods Through : #{@bill.transporter_name.capitalize}" , size: 9, :inline_format => true
           end
      end
        
      bounding_box([320,520], :width => 200) do
         if @bill.gc_lr_number == ""
           text "LR Number : NA" , :inline_format => true,  size: 9
         else
           text "LR Number : #{@bill.gc_lr_number}" , :inline_format => true, size: 9
         end
      end
        
      bounding_box([3,500], :width => 300) do
         if @bill.vechicle_number == ""
           text "Vehicle Number :  NA" , :inline_format => true, size: 9
         else
           text "Vehicle Number : #{@bill.vechicle_number} " , :inline_format => true, size: 9
         end
      end
        
      bounding_box([320,500], :width => 300) do
          if @bill.lr_date == nil
            text "LR Date       : NA" , :inline_format => true, size: 9
          else
            text "LR Date       : #{@bill.lr_date.strftime("%d %b %Y")} " , :inline_format => true, size: 9
          end
      end
   end
            

    def bill_products
      [["Goods Description", "Tax % (VAT/CST)", "Service Tax%","Quantity", "Unit Price", "Total Price"]] + 
      @bill.line_items.map do|line_item|
        
        qty = line_item.quantity
        if qty % 1 == 0.0
           qty = qty.to_i
        else
          qty = qty
        end
        
        if line_item.tax_id.present?
          tax = line_item.tax.tax_rate
        else
          tax = 'NA'
        end
        
        if line_item.service_tax_rate.present?
          service_tax = line_item.service_tax_rate
        else
          service_tax = "NA"
        end
        #product details
         if line_item.item_description.present?
           product_name = "#{line_item.product.product_name.titleize} \n #{item = line_item.item_description}"
        else
          product_name = line_item.product.product_name.titleize
        end
     
        [product_name, tax, service_tax, qty, "#{number_with_delimiter(line_item.unit_price,delimiter: ',')}", "#{number_with_delimiter(line_item.total_price.round(2), delimiter: ',')}"]
      end
   end
 
   def bill_table   
      bounding_box([5,510], :width => 530) do
        move_down 30
         table bill_products do
           #self.align_headers = :center
           row(0).font_style = :bold
           row(0).align = :center
           row(0).background_color = '778899'   
           #  row(0).row_color =  :FFFFFF
           # row(0).row_color = "FF0000"
           #row(0).columns(1..5).align = :center
           columns(0).align = :left   
           column(1..2).align = :center
           column(3..5).align = :right
           columns(0..5).size = 9
           #self.row_colors = ["FFFFFF", "DDDDDD"]
           #self.row_colors = ["FFFFFF", "D3D3D3"]
           self.header = true
           self.width = 530
           self.column(0).width = 145
           self.column(1).width = 65
           self.column(2).width = 65
           self.column(3).width = 70
           self.column(4).width = 90
           self.column(5).width = 95
           
         end
      end
   end
   
   def table_price_list
     move_down 5
     #bill total
         data =  [["Bill Total", "#{number_with_delimiter(@bill.total_bill_price.round(2), delimiter: ',')}"]]
table(data,  :cell_style => {size: 9, :inline_format => true, :align => :right},:column_widths => [160, 95], :position => 280)
        #Other charges like packing, transportation
         if @bill.other_charges_information_id != nil
            data = [["#{@bill.other_charges_information.other_charges}", "#{number_with_delimiter(@bill.other_charges, delimiter: ',')}"]]
table(data, :cell_style => {size: 9, :inline_format => true, :align => :right},:column_widths => [160, 95], :position => 280)
         end
        #Discount Details
         if @bill.discount.present?
           data = [[" Discount", "#{number_with_delimiter(@bill.discount.round(2), delimiter: ',')}"]]
           table(data, :cell_style => {size: 9, :inline_format => true, :align => :right}, :column_widths => [160, 95], :position => 280)        end
         #Sub total 
         sub_total = @bill.total_bill_price.to_f + @bill.other_charges.to_f - @bill.discount.to_f
         data = [["Sub Total", "#{number_with_delimiter(sub_total.round(2), delimiter: ',')}"]]
         table(data, :cell_style => {size: 9, :font_style => :bold, :inline_format => true, :align => :right}, :column_widths => [160, 95], :position => 280)
        #Tax details
        taxes = @bill.line_items.pluck(:tax_id)
        if taxes.any?
          taxes_id = taxes.uniq
          taxes_id.each do |line_item_tax|
            if line_item_tax != nil
              tax_rate = Tax.where(:id => line_item_tax).first.tax_rate
              tax_type = Tax.where(:id => line_item_tax).first.tax_type
              line_items = @bill.line_items.where(:tax_id => line_item_tax)
              line_items_total_price = line_items.sum(:total_price)
              data = [["#{tax_type} @ #{tax_rate} % on #{line_items_total_price}", "#{number_with_delimiter((line_items_total_price * (tax_rate/100)).round(2))}"]]
              table(data, :cell_style => {size: 9, :inline_format => true, :align => :right}, :column_widths => [160, 95], :position => 280)
            end
          end
        end
         #Service Tax details
         service_tax = @bill.line_items.pluck(:service_tax_rate)
         if service_tax.present?
           service_tax = @bill.line_items.pluck(:service_tax_rate)
           service_tax_rates = @bill.line_items.map(&:service_tax_rate) 
           service_tax_rates = service_tax_rates.uniq 
           service_tax_rates.each do |service_tax| 
             if service_tax != nil
               line_items = @bill.line_items.where(:service_tax_rate => service_tax)
               line_items_total_price = line_items.sum(:total_price) 
               data = [[" Service Tax @ #{service_tax} % on #{line_items_total_price}", "#{((service_tax/100) * line_items_total_price).round(2)}"]]   
               table(data, :cell_style => {size: 9, :inline_format => true, :align => :right}, :column_widths => [160, 95], :position => 280)
             end
           end
         end 
         
       #Grand total
        data = [["Grand Total", "#{number_with_delimiter(@bill.grand_total.round(2), delimiter: ',')}"]]
        table(data, :cell_style => {size: 9,  :align => :right, :font_style => :bold}, :column_widths => [160, 95], :position => 280)

       data = [["Amount in words", "Rupees #{@bill.grand_total.round.to_words} only"]]
       table(data, :cell_style => {size: 9, :font_style => :bold, :align => :center}, :column_widths => [140, 392], :position => 3)
   end

      
   def authority
     move_down 20
     #check user is primary or secondary user
     role_name = @user.main_roles.pluck(:role_name)
     if role_name.include? "user"
       if @user.main_roles.first.role_name =="user"
           company = @bill.authuser.users.first.company
       elsif @user.main_roles.first.role_name == "client"
            company = @bill.authuser.clients.first.company
       end
     elsif role_name.include? "secondary_user"
       primary_user_id = @bill.authuser.invited_by_id
       company = Authuser.find(primary_user_id).users.first.company
     end
       
   
       if company.length >= 25
         indent(300) do
           if role_name.include? "user"
             if @user.main_roles.first.role_name == "user"
               text "For "+@bill.authuser.users.first.company.titleize,  size: 10, :style => :bold
               #text "For iPrimitus Consultancy Services", size: 11, style: :bold
             elsif @user.main_roles.first.role_name  == "client"
               text "For "+@bill.authuser.clients.first.company.titleize,  size: 10, :style => :bold
             end
           elsif role_name.include? "secondary_user"
             primary_user_id = @bill.authuser.invited_by_id
             text "For "+Authuser.find(primary_user_id).users.first.company.titleize,  size: 10, :style => :bold
           end
         move_down 10
         text "Authorized Signatory",  size: 10, :style => :bold
         end
       else
          indent(350) do
             if role_name.include? "user"
               if @user.main_roles.first.role_name == "user"
                 text "For "+@bill.authuser.users.first.company.titleize,  size: 10, :style => :bold
                  # text "For iPrimitus Consultancy Services", size: 11, style: :bold
               elsif @user.main_roles.first.role_name  == "client"
                 text "For "+@bill.authuser.clients.first.company.titleize,  size: 10, :style => :bold
               end
             elsif role_name.include? "secondary_user"
               primary_user_id = @bill.authuser.invited_by_id
               text "For "+Authuser.find(primary_user_id).users.first.company.titleize,  size: 10, :style => :bold
             end
             move_down 30
             text "Authorized Signatory",  size: 10, :style => :bold
          end
       end
   end

   def terms_and_conditions
           #stroke_rectangle [3,160], 400, 80
       move_down 40
       indent 10 do
           text "Terms and Conditions", size: 10, :style => :bold
           text "", size: 9
           text "1. Interest @ 24% per annum will be charged on the bills remaining unpaid after 15 days.", size: 9
           text "2. No claim will be entertained after goods are duly accepted.",  size: 9
           text "3. Goods once sold cannot be taken back or exchanged.", size: 9
           text "4. Subject to Bangalore Jurisdiction.",  size: 9
       end
     
         #repeat :all do
          #Create a bounding box and move it up 18 units from the bottom boundry of the page
          # bounding_box [bounds.left, bounds.bottom + 18], width: bounds.width do
           # text "We Thank You for Your Business", size: 10, align: :center
           #end
        # end
   end

end

  
  #end
 
#def footer
 # move_down 70
 # indent 200 do
 #text "We Thank You for your Business", size: 12
#end
#end

#end
#repeat :all do
#bounding_box([bounds.right - 59, bounds.bottom - -20], :width => 60, :height => 20) do

 # pagecount = page_count
 # text "Page #{pagecount}"
#end
#end
#string = "page <page> of <total>"
#options = { :at =>  [250, 0],
 # :start_count_at => 1}
#number_pages string, options
  
 
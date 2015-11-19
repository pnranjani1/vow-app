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
    # bill_table
  #   table_price_list
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
       else
         bounding_box([10,690], width: 200) do
           text "#{@user.users.first.company.titleize}",size: 10, :style => :bold, align: :center
         end
       end
      elsif @user.main_roles.first.role_name == "secondary_user"
        primary_user_id = @user.invited_by_id
        user = Authuser.find(primary_user_id)
        if user.image.present?
          image open(user.image_url), height: 50, width: 90, crop: "fit", :at => [10,710]
        else
          bounding_box([10,690], width: 200) do
            text "#{user.users.first.company.titleize}",size: 10, :style => :bold, align: :center
          end
        end
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
      bounding_box([3,525], :width => 300) do
        if @bill.transporter_name == ""
           text "Goods Through : NA" , size: 9, :inline_format => true
        else
            text "Goods Through : #{@bill.transporter_name.capitalize}" , size: 9, :inline_format => true
        end
      end
        
      bounding_box([320,525], :width => 200) do
         if @bill.gc_lr_number == ""
           text "LR Number : NA" , :inline_format => true,  size: 9
         else
           text "LR Number : #{@bill.gc_lr_number}" , :inline_format => true, size: 9
         end
      end
        
      bounding_box([3,505], :width => 300) do
         if @bill.vechicle_number == ""
           text "Vehicle Number :  NA" , :inline_format => true, size: 9
         else
           text "Vehicle Number : #{@bill.vechicle_number} " , :inline_format => true, size: 9
         end
      end
        
      bounding_box([320,505], :width => 300) do
          if @bill.lr_date == nil
            text "LR Date       : NA" , :inline_format => true, size: 9
          else
            text "LR Date       : #{@bill.lr_date.strftime("%d %b %Y")} " , :inline_format => true, size: 9
          end
      end
   end
            

   def bill_products
     [["Goods Description", "Tax","Quantity", "Unit Price", "Total Price"]] + 
      @bill.line_items.map do|line_item|
        
        qty = line_item.quantity
        if qty % 1 == 0.0
           qty = qty.to_i
        else
          qty = qty
        end
        
        if line_item.bill_taxes.present?
         line_item.bill_taxes.each do |tax| 
           tax_type =  tax.tax.tax_type 
           if tax_type == "Percentage" 
             tax.tax_type 
           else  
             tax.tax_type 
           end 
         end
        end
      end
   end
        #removed due to db design change
       # if line_item.tax_id.present?
       #   tax = line_item.tax.tax_rate
       # else
       #   tax = 'NA'
       # end
        
        #if line_item.service_tax_rate.present?
        #  service_tax = line_item.service_tax_rate
        #else
        #  service_tax = "NA"
        #end
       
      
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
  
 
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
     font "Times-Roman"
      draw_text "INVOICE", :at => [225,690],size: 21
      #if @bill.bill_date == nil
      # @bill.bill_date = Date.today
     #end
     bounding_box([320, 670], :width => 300) do
       text "<b>Invoice Number   :</b> #{@bill.invoice_number}" ,size:11, :inline_format => true, :leading => 3
      text "<b>Invoice Date         :</b> #{@bill.bill_date.strftime("%b %d, %Y")}" ,size:11, :inline_format => true
    end
  
    bounding_box([8, 640], :width => 300) do
      if @bill.esugam == nil
        text "<b>E-Sugam Number:</b> NA", :inline_format => true, size: 11
      else
        text "</b>E-Sugam Number:</b> #{@bill.esugam}", :inline_format=> true, size: 11
      end
    end
   end
  
   def bill_user   
      #draw_text "Company Details", :at => [8,620], size:15
      bounding_box([8,610],:width =>250) do
        if @user.main_roles.first.role_name == "user"
          text "#{@bill.authuser.users.first.company.titleize}",size: 14, :style => :bold, :leading => 3
        elsif @user.main_roles.first.role_name  == "secondary_user"
          primary_user_id = @user.invited_by_id
          text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 14, :style => :bold, :leading => 3
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company.titleize}",size: 14, :style => :bold, :leading => 3
        end 
        # Get the address details of user for secondary user bill
        role_name = @user.main_roles.pluck(:role_name)
        unless role_name.include? "secondary_user"
        
          text "<b>Address               :</b>    #{@bill.authuser.address.address_line_1.capitalize}, " + "#{@bill.authuser.address.address_line_2}, " + "#{@bill.authuser.address.address_line_3}" , :inline_format => true, size: 11, :leading => 3
          text "<b>City                     :</b>    #{@bill.authuser.address.city.capitalize}", :inline_format => true, size: 11, :leading => 3
        #text "Country :#{@bill.authuser.address.country}"
          text "<b>Phone Number   :</b>   #{@bill.authuser.membership.phone_number}", :inline_format => true, size: 11, :leading => 3
          text "<b>Tin Number        :</b>   #{@bill.authuser.users.first.tin_number}", :inline_format => true, size: 11
        else
          primary_user_id = @bill.authuser.invited_by_id
          text "<b>Address               :</b>    #{Authuser.find(primary_user_id).address.address_line_1.capitalize}, " + "#{Authuser.find(primary_user_id).address.address_line_2}, " + "#{Authuser.find(primary_user_id).address.address_line_3}" , :inline_format => true, size: 11, :leading => 3
          text "<b>City                     :</b>    #{Authuser.find(primary_user_id).address.city.capitalize}", :inline_format => true, size: 11, :leading => 3
        #text "Country :#{@bill.authuser.address.country}"
          text "<b>Phone Number   :</b>   #{Authuser.find(primary_user_id).membership.phone_number}", :inline_format => true, size: 11, :leading => 3
          text "<b>Tin Number        :</b>   #{Authuser.find(primary_user_id).users.first.tin_number}", :inline_format => true, size: 11
        end
      end
   end

   def logo(user)
      role_name = @user.main_roles.pluck(:role_name)
      if role_name.include? "user"
       if @user.image.present?
         image open(@user.image_url), height: 50, width: 70, crop: "fit", :at => [10,710]
       end
      elsif @user.main_roles.first.role_name == "secondary_user"
        primary_user_id = @user.invited_by_id
        image open(Authuser.find(primary_user_id).image_url), height: 50, width: 70, crop: "fit", :at => [10,710]
      end
   end
        # gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        # size = 50
        #gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}?s=#{size}"+".jpg"
        #image open(gravatar_url), :at => [10,710]
   
     
  
   def bill_customer
      draw_text "Billing Name", :at => [320, 620], size: 15
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
         
      bounding_box([320, 610],:width => 220) do
        text "#{@bill.customer.name.titleize}", size:14, :style => :bold
        text "<b>Address               :</b>   #{@bill.customer.address.capitalize}" , :inline_format => true, size: 11, :leading => 3 
        text "<b>City                      :</b>   #{@bill.customer.city.capitalize}", size: 11, :inline_format => true, :leading => 3
       # text "<b>PinCode               :</b>   #{@bill.customer.pin_code}", size: 11, :inline_format => true, :leading => 3
        text "<b>Phone  Number   :</b>  #{@bill.customer.phone_number}", size: 11, :inline_format => true, :leading => 3
        text "<b>Tin  Number        :</b>  #{@bill.customer.tin_number}", size: 11, :inline_format => true
      end
   end
     
   def bill_line 
      move_down 20
      stroke_horizontal_rule
   end
      
       
   def bill_transport   
      bounding_box([3,480], :width => 300) do
          if @bill.transporter_name == ""
            text "<b>Goods Through :</b> NA" , size: 11, :inline_format => true
          else
            text "<b>Goods Through :</b> #{@bill.transporter_name.capitalize}" , :style => :bold,  size: 11, :inline_format => true
           end
      end
        
      bounding_box([320,480], :width => 200) do
         if @bill.gc_lr_number == ""
           text "<b>LR Number :</b> NA" , :inline_format => true,  size: 11
         else
           text "<b>LR Number :</b> #{@bill.gc_lr_number}" , :inline_format => true, size: 11
         end
      end
        
      bounding_box([3,450], :width => 300) do
         if @bill.vechicle_number == ""
           text "<b>Vehicle Number : </b> NA" , :inline_format => true, size: 11
         else
           text "<b>Vehicle Number :</b> #{@bill.vechicle_number} " , :inline_format => true, size: 11
         end
      end
        
      bounding_box([320,450], :width => 300) do
          if @bill.lr_date == nil
            text "<b>LR Date       :</b> NA" , :inline_format => true, size: 11
          else
            text "<b>LR Date       :</b> #{@bill.lr_date.strftime("%d %b %Y")} " , :inline_format => true, size: 11
          end
      end
   end
            

    def bill_products
      [["Products","Quantity", "Unit Price", "Total Price", "Service Tax Rate"]] + 
      @bill.line_items.map do|line_item|
          qty = line_item.quantity
            if qty % 1 == 0.0
              qty = qty.to_i
            else
              qty = qty
            end
        if line_item.service_tax_rate.present?
          service_tax = line_item.service_tax_rate
        else
          service_tax = "NA"
        end
        [line_item.product.product_name.titleize, qty, "#{number_with_delimiter(line_item.unit_price,delimiter: ',')}", "#{number_with_delimiter(line_item.total_price.round(2), delimiter: ',')}", service_tax]
      end
   end
 
   def bill_table   
      bounding_box([5,440], :width => 530) do
        move_down 30
         table bill_products do
           row(0).font_style = :bold
           row(0).background_color = '778899'   
           #  row(0).row_color =  :FFFFFF
           # row(0).row_color = "FF0000"
           columns(0..4).align = :center          
           #self.row_colors = ["FFFFFF", "DDDDDD"]
           #self.row_colors = ["FFFFFF", "D3D3D3"]
           self.header = true
           self.width = 530
           self.column(0).width = 135
           self.column(1).width = 100
           self.column(2).width = 100
           self.column(3).width = 115
           self.column(4).width = 80
         end
      end
   end
   
  
      

   def table_price_list
     move_down 10
         data =  [["<b>Bill Total</b>", "#{number_with_delimiter(@bill.total_bill_price.round(2), delimiter: ',')}"]]
table(data,  :cell_style => {:inline_format => true, :align => :center},:column_widths => [125, 110], :position => 300)
        
         if @bill.other_charges_information_id != nil
            data = [["<b>#{@bill.other_charges_information.other_charges}</b>", "#{number_with_delimiter(@bill.other_charges, delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :center},:column_widths =>[125, 110], :position => 300)
         elsif @bill.other_charges_information_id == nil
           data = [["<b>Other Charges</b>", "NA"]]
table(data, :cell_style => {:inline_format => true, :align => :center},:column_widths =>[125, 110], :position => 300)
         end
          
          sub_total = @bill.total_bill_price.to_f + @bill.other_charges.to_f
         data = [["<b>Sub Total</b>", "#{number_with_delimiter(sub_total.round(2), delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :center}, :column_widths => [125, 110], :position => 300)

         if @bill.other_charges != nil     
           total = @bill.total_bill_price + @bill.other_charges
           data = [["<b>#{@bill.tax.tax} on #{number_with_delimiter(total.round(2), delimiter: ',')}</b>", "#{number_with_delimiter((@bill.tax.tax_rate*0.01* total).round(2), delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :center},:column_widths => [125, 110], :position => 300)
         else 
            total = @bill.total_bill_price 
            data = [["<b>#{@bill.tax.tax} on #{number_with_delimiter(total, delimiter: ',')}</b>", "#{(@bill.tax.tax_rate*0.01* total).round(2)}"]]
table(data, :cell_style => {:inline_format => true, :align => :center},:column_widths => [125, 110], :position => 300)    
         end

         service_tax = @bill.line_items.pluck(:service_tax_rate)
         if service_tax.present?
           data = [["<b>Service Tax Amount </b>", "#{number_with_delimiter(@bill.line_items.sum(:service_tax_amount).round(2), delimiter: ',')}"]]
           table(data, :cell_style => {:inline_format => true, :align => :center}, :column_widths => [125, 110], :position => 300)
         end

data = [["<b>Grand Total</b>", "#{number_with_delimiter((@bill.grand_total + @bill.line_items.sum(:service_tax_amount)).round(2), delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :center}, :column_widths => [125, 110], :position => 300)

data = [["Amount in words", "Rupees #{(@bill.grand_total + @bill.line_items.sum(:service_tax_amount)).round.to_words} only"]]
         table(data, :cell_style => {:font_style => :bold, :align => :center}, :column_widths => [140, 392], :position => 3)
   end

      
   def authority
     move_down 80
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
               text "For "+@bill.authuser.users.first.company.titleize,  size: 11, :style => :bold
               #text "For iPrimitus Consultancy Services", size: 11, style: :bold
             elsif @user.main_roles.first.role_name  == "client"
               text "For "+@bill.authuser.clients.first.company.titleize,  size: 11, :style => :bold
             end
           elsif role_name.include? "secondary_user"
             primary_user_id = @bill.authuser.invited_by_id
             text "For "+Authuser.find(primary_user_id).users.first.company.titleize,  size: 11, :style => :bold
           end
         move_down 30
         text "Authorized Signatory",  size: 11, :style => :bold
         end
       else
          indent(350) do
             if role_name.include? "user"
               if @user.main_roles.first.role_name == "user"
                 text "For "+@bill.authuser.users.first.company.titleize,  size: 11, :style => :bold
                  # text "For iPrimitus Consultancy Services", size: 11, style: :bold
               elsif @user.main_roles.first.role_name  == "client"
                 text "For "+@bill.authuser.clients.first.company.titleize,  size: 11, :style => :bold
               end
             elsif role_name.include? "secondary_user"
               primary_user_id = @bill.authuser.invited_by_id
               text "For "+Authuser.find(primary_user_id).users.first.company.titleize,  size: 11, :style => :bold
             end
             move_down 30
             text "Authorized Signatory",  size: 11, :style => :bold
          end
       end
   end

   def terms_and_conditions
           #stroke_rectangle [3,160], 400, 80
       move_down 40
       indent 10 do
           text "Terms and Conditions", size: 11, :style => :bold
           text "", size: 10
           text "1. Interest @ 24% per annum will be charged on the bills remaining unpaid after 15 days.", size: 10
           text "2. No claim will be entertained after goods are duly accepted.",  size: 10
           text "3. Goods once sold cannot be taken back or exchanged.", size: 10
           text "4. Subject to Bangalore Jurisdiction.",  size: 10
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
  
 
class BillPdfThree < Prawn::Document
  require 'prawn/table'
  require "open-uri"
  include ActionView::Helpers::NumberHelper
  
  
   def initialize(bill)
    super()
     @bill = bill
     @user = Authuser.find(@bill.authuser_id)
     bill_title
    
     
     bill_user
     logo(@user)
     bill_customer
     bill_products
     bill_table
     table_price_list
     authority
     terms_and_conditions
     #footer
    
   end


 # :margin => [10, 20, 30, 40]
      
   def bill_title    
    # font "Times-Roman"
     font "Helvetica"
     draw_text "INVOICE", :at => [400,700],size: 25
      #if @bill.bill_date == nil
      # @bill.bill_date = Date.today
     #end
     bounding_box([320, 670], :width => 300) do
       text "<b>Invoice Number     :</b>    #{@bill.invoice_number}" ,size:11, :inline_format => true, :leading => 5
      text "<b>Invoice Date           :</b>    #{@bill.bill_date.strftime("%b %d, %Y")}" ,size:11, :inline_format => true, :leading => 5
      if @bill.esugam == nil
        text "<b>E-Sugam Number  :</b>    NA", :inline_format => true, size: 11, :leading => 5
      else
        text "<b>E-Sugam Number  :</b>   #{@bill.esugam}", :inline_format => true, size: 11, :leading => 5
      end
     text "<b>Amount due(INR)   :</b> #{@bill.grand_total.round(2)}" ,size:11, :inline_format => true
    end
  
    bounding_box([8, 640], :width => 300) do
     
    end
   end
  
   def bill_user   
      #draw_text "Company Details", :at => [8,620], size:15
      bounding_box([10,570],:width =>250) do
        if @user.main_roles.first.role_name == "user"
          text "#{@bill.authuser.users.first.company.titleize}",size: 14, :style => :bold, :leading => 3
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company.titleize}",size: 14, :style => :bold, :leading => 3
        end 
        text "#{@bill.authuser.address.address_line_1.capitalize}, " + "#{@bill.authuser.address.address_line_2}, " + "#{@bill.authuser.address.address_line_3}" ,size: 11, :leading => 3
        text "#{@bill.authuser.address.city.capitalize}", size: 11, :leading => 3
        #text "Country :#{@bill.authuser.address.country}"
        text "Mobile Number  :  #{@bill.authuser.membership.phone_number}", size: 11, :leading => 3
        text "Tin Number       :   #{@bill.authuser.users.first.tin_number}", size: 11, :leading => 3
      end
   end

   def logo(user)
       if @user.image.present?
         image open(@user.image_url), height: 90, width: 200, crop: "fit", :at => [10,690]
       else
         bounding_box([10,650], width: 200) do
           if @user.main_roles.first.role_name == "user"
            text "#{@bill.authuser.users.first.company.titleize}",size: 14, :style => :bold, align: :center
           elsif @user.main_roles.first.role_name  == "client"
            text "#{@bill.authuser.clients.first.company.titleize}",size: 14, :style => :bold, align: :center
           end 
         end
       end
   end
        # gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        # size = 50
        #gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}?s=#{size}"+".jpg"
        #image open(gravatar_url), :at => [10,710]
   
     
  
   def bill_customer
      draw_text "Bill To,", :at => [320, 560], size: 12
      bounding_box([320, 550],:width => 220) do
        text "#{@bill.customer.name.titleize}", size:14, :style => :bold, :leading => 3
        text "#{@bill.customer.address.capitalize}", size: 11 , :leading => 3
        text "#{@bill.customer.city.capitalize}", size: 11, :leading => 3
        text "#{@bill.customer.pin_code}", size: 11, :leading => 3
        text "Phone  Number  :  #{@bill.customer.phone_number}", size: 11, :leading => 3
        text "Tin  Number        :  #{@bill.customer.tin_number}", size: 11, :leading => 3
      end
   end
     
  
     

    def bill_products
      [["Products","Quantity", "Unit Price", "Total Price"]] + 
      @bill.line_items.map do|line_item|
          qty = line_item.quantity
            if qty % 1 == 0.0
              qty = qty.to_i
            else
              qty = qty
            end
        [line_item.product.product_name.titleize, qty, "#{number_with_delimiter(line_item.unit_price,delimiter: ',')}", "#{number_with_delimiter(line_item.total_price.round(2), delimiter: ',')}"]
      end
   end
 
   def bill_table   
      bounding_box([5,440], :width => 550) do
        move_down 30
         table bill_products do
           row(0).font_style = :bold
           columns(0..3).align = :center          
           self.header = true
           self.width = 530
           self.column(0).width = 120
           self.column(1).width = 75
           self.column(2).width = 115
           self.column(2).width = 100
         end
      end
   end
   
  
      

   def table_price_list
     move_down 30
         data =  [["<b>Bill Total</b>", "#{number_with_delimiter(@bill.total_bill_price.round(2), delimiter: ',')}"]]
table(data,  :cell_style => {:inline_format => true, :align => :center},:column_widths => [125, 110], :position => 300)
        
         if @bill.other_charges_information_id != nil
            data = [["<b>#{@bill.other_charges_information.other_charges}</b>", "#{number_with_delimiter(@bill.other_charges, delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :center},:column_widths =>[125, 110], :position => 300)
         elsif @bill.other_charges_information_id == nil
           data = [["<b>Other Charges</b>", "NA"]]
table(data, :cell_style => {:inline_format => true, :align => :center},:column_widths =>[125, 110], :position => 300)
         end
          
         if @bill.other_charges != nil     
           total = @bill.total_bill_price + @bill.other_charges
           data = [["<b>#{@bill.tax.tax} on #{number_with_delimiter(total.round(2), delimiter: ',')}</b>", "#{number_with_delimiter((@bill.tax.tax_rate*0.01* total).round(2), delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :center},:column_widths => [125, 110], :position => 300)
         else 
            total = @bill.total_bill_price 
            data = [["<b>#{@bill.tax.tax} on #{number_with_delimiter(total, delimiter: ',')}</b>", "#{(@bill.tax.tax_rate*0.01* total).round(2)}"]]
table(data, :cell_style => {:inline_format => true, :align => :center},:column_widths => [125, 110], :position => 300)    
         end


         data = [["<b>Grand Total</b>", "#{number_with_delimiter(@bill.grand_total.round(2), delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :center}, :column_widths => [125, 110], :position => 300)

       
   end

      
   def authority
      move_down 40
       if @user.main_roles.first.role_name =="user"
           company = @bill.authuser.users.first.company
       elsif @user.main_roles.first.role_name == "client"
            company = @bill.authuser.clients.first.company
       end
   
       if company.length >= 25
         indent(300) do
             if @user.main_roles.first.role_name == "user"
               text "For "+@bill.authuser.users.first.company.titleize,  size: 11, :style => :bold
               #text "For iPrimitus Consultancy Services", size: 11, style: :bold
             elsif @user.main_roles.first.role_name  == "client"
               text "For "+@bill.authuser.clients.first.company.titleize,  size: 11, :style => :bold
             end
         move_down 30
         text "Authorized Signatory",  size: 11, :style => :bold
         end
       else
          indent(350) do
               if @user.main_roles.first.role_name == "user"
                 text "For "+@bill.authuser.users.first.company.titleize,  size: 11, :style => :bold
                  # text "For iPrimitus Consultancy Services", size: 11, style: :bold
               elsif @user.main_roles.first.role_name  == "client"
                 text "For "+@bill.authuser.clients.first.company.titleize,  size: 11, :style => :bold
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
     
         repeat :all do
          #Create a bounding box and move it up 18 units from the bottom boundry of the page
           bounding_box [bounds.left, bounds.bottom + 18], width: bounds.width do
            text "We Thank You for Your Business", size: 10, align: :center
           end
         end
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
  
 
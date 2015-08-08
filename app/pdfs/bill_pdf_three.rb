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
     text "<b>Amount due (INR)  :</b>  #{(@bill.grand_total + @bill.line_items.sum(:service_tax_amount)).round(2)}" ,size:11, :inline_format => true
    end
  
    bounding_box([8, 640], :width => 300) do
     
    end
   end
  
   def bill_user   
      #draw_text "Company Details", :at => [8,620], size:15
      bounding_box([10,570],:width =>250) do
        if @user.main_roles.first.role_name == "user"
          text "#{@bill.authuser.users.first.company.titleize}",size: 14, :style => :bold, :leading => 3
        elsif @user.main_roles.first.role_name  == "secondary_user"
          primary_user_id = @user.invited_by_id
          text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 14, :style => :bold, :leading => 3
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company.titleize}",size: 14, :style => :bold, :leading => 3
        end 
        
        role_name = @user.main_roles.pluck(:role_name)
        unless role_name.include? "secondary_user"
          text "#{@bill.authuser.address.address_line_1.capitalize}, " + "#{@bill.authuser.address.address_line_2}, " + "#{@bill.authuser.address.address_line_3}" ,size: 11, :leading => 3
          text "#{@bill.authuser.address.city.capitalize}", size: 11, :leading => 3
          #text "Country :#{@bill.authuser.address.country}"
          text "Mobile Number  :  #{@bill.authuser.membership.phone_number}", size: 11, :leading => 3
          text "Tin Number       :   #{@bill.authuser.users.first.tin_number}", size: 11, :leading => 3
        else
          primary_user_id = @bill.authuser.invited_by_id
          text "#{Authuser.find(primary_user_id).address.address_line_1.capitalize}, " + "#{Authuser.find(primary_user_id).address.address_line_2}, " + "#{Authuser.find(primary_user_id).address.address_line_3}" ,size: 11, :leading => 3
          text "#{Authuser.find(primary_user_id).address.city.capitalize}", size: 11, :leading => 3
          #text "Country :#{@bill.authuser.address.country}"
          text "Mobile Number  :  #{Authuser.find(primary_user_id).membership.phone_number}", size: 11, :leading => 3
          text "Tin Number       :   #{Authuser.find(primary_user_id).users.first.tin_number}", size: 11, :leading => 3
        end
      end
   end

   def logo(user)
      role_name = @user.main_roles.pluck(:role_name)
      if role_name.include? "user"
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
      elsif @user.main_roles.first.role_name == "secondary_user"
        primary_user_id = @user.invited_by_id
          if Authuser.find(primary_user_id).image.present?
            image open(Authuser.find(primary_user_id).image_url), height: 50, width: 70, crop: "fit", :at => [10,710]
          else
             bounding_box([10,650], width: 200) do
               text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 14, :style => :bold, align: :center
             end
          end
      end
   end
   
   def bill_customer
      draw_text "Bill To,", :at => [320, 560], size: 12
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
         
      bounding_box([320, 550],:width => 220) do
        text "#{@bill.customer.name.titleize}", size:14, :style => :bold, :leading => 3
        text "#{@bill.customer.address.capitalize}", size: 11 , :leading => 3
        text "#{@bill.customer.city.capitalize}", size: 11, :leading => 3
        #text "#{@bill.customer.pin_code}", size: 11, :leading => 3
        text "Phone  Number  :  #{@bill.customer.phone_number}", size: 11, :leading => 3
        text "Tin  Number        :  #{@bill.customer.tin_number}", size: 11, :leading => 3
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
      bounding_box([5,440], :width => 550) do
        move_down 30
         table bill_products do
           row(0).font_style = :bold
           columns(0..4).align = :center          
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
           data = [["<b>Service Tax Amount</b>", "#{number_with_delimiter(@bill.line_items.sum(:service_tax_amount).round(2), delimiter: ',')}"]]
           table(data, :cell_style => {:inline_format => true, :align => :center}, :column_widths => [125, 110], :position => 300)
         end

data = [["<b>Grand Total</b>", "#{number_with_delimiter((@bill.grand_total+ @bill.line_items.sum(:service_tax_amount)).round(2), delimiter: ',')}"]]
        table(data, :cell_style => {:inline_format => true, :align => :center}, :column_widths => [125, 110], :position => 300)
   end

      
   def authority
      move_down 40
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
       move_down 80
       indent 10 do
           text "Terms and Conditions", size: 11, :style => :bold
           text "", size: 10
           text "1. Interest @ 24% per annum will be charged on the bills remaining unpaid after 15 days.", size: 10
           text "2. No claim will be entertained after goods are duly accepted.",  size: 10
           text "3. Goods once sold cannot be taken back or exchanged.", size: 10
           text "4. Subject to Bangalore Jurisdiction.",  size: 10
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
  
 
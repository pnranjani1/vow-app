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

   def bill_title    
    # font "Times-Roman"
     font "Helvetica"
     draw_text "INVOICE", :at => [400,700],size: 15
      #if @bill.bill_date == nil
      # @bill.bill_date = Date.today
     #end
     bounding_box([320, 670], :width => 300) do
       text "Invoice Number     :    #{@bill.invoice_number}" ,size:9, :inline_format => true, :leading => 3
      text "Invoice Date           :    #{@bill.bill_date.strftime("%b %d, %Y")}" ,size:9, :inline_format => true, :leading => 3
      if @bill.esugam == nil
        text "e-Sugam Number  :    NA", :inline_format => true, size: 9, :leading => 3
      else
        text "e-Sugam Number  :   #{@bill.esugam}", :inline_format => true, size: 9, :leading => 3
      end
     text "Amount due (INR)  :  #{@bill.grand_total.round(2)}" ,size:9, :inline_format => true
    end
   #  bounding_box([8, 640], :width => 300) do
   #  end
   end
  
   def bill_user   
      #draw_text "Company Details", :at => [8,620], size:15
      bounding_box([10,590],:width =>250) do
        if @user.main_roles.first.role_name == "user"
          text "#{@bill.authuser.users.first.company.titleize}",size: 10, :style => :bold, :leading => 2
        elsif @user.main_roles.first.role_name  == "secondary_user"
          primary_user_id = @user.invited_by_id
          text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 10, :style => :bold, :leading => 2
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company.titleize}",size: 10, :style => :bold, :leading => 2
        end 
        
        role_name = @user.main_roles.pluck(:role_name)
        unless role_name.include? "secondary_user"
          text "#{@bill.authuser.address.address_line_1.capitalize}, " + "#{@bill.authuser.address.address_line_2}, " + "#{@bill.authuser.address.address_line_3}" ,size: 9, :leading => 2
          text "#{@bill.authuser.address.city.capitalize}", size: 9, :leading => 2
          #text "Country :#{@bill.authuser.address.country}"
          text "Mobile Number  :  #{@bill.authuser.membership.phone_number}", size: 9, :leading => 2
          text "Tin Number       :   #{@bill.authuser.users.first.tin_number}", size: 9, :leading => 2
        else
          primary_user_id = @bill.authuser.invited_by_id
          text "#{Authuser.find(primary_user_id).address.address_line_1.capitalize}, " + "#{Authuser.find(primary_user_id).address.address_line_2}, " + "#{Authuser.find(primary_user_id).address.address_line_3}" ,size: 9, :leading => 2
          text "#{Authuser.find(primary_user_id).address.city.capitalize}", size: 9, :leading => 2
          #text "Country :#{@bill.authuser.address.country}"
          text "Mobile Number  :  #{Authuser.find(primary_user_id).membership.phone_number}", size: 9, :leading => 2
          text "Tin Number       :   #{Authuser.find(primary_user_id).users.first.tin_number}", size: 9, :leading => 2
        end
      end
   end

   def logo(user)
      role_name = @user.main_roles.pluck(:role_name)
      if role_name.include? "user"
        if @user.image.present?
         image open(@user.image_url), height: 90, width: 150, crop: "fit", :at => [10,690]
        else
         bounding_box([10,650], width: 200) do
           if @user.main_roles.first.role_name == "user"
            text "#{@bill.authuser.users.first.company.titleize}",size: 10, :style => :bold, align: :center
           elsif @user.main_roles.first.role_name  == "client"
            text "#{@bill.authuser.clients.first.company.titleize}",size: 10, :style => :bold, align: :center
           end 
         end
        end
      elsif @user.main_roles.first.role_name == "secondary_user"
        primary_user_id = @user.invited_by_id
          if Authuser.find(primary_user_id).image.present?
            image open(Authuser.find(primary_user_id).image_url), height: 50, width: 70, crop: "fit", :at => [10,710]
          else
             bounding_box([10,650], width: 200) do
               text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 10, :style => :bold, align: :center
             end
          end
      end
   end
   
   def bill_customer
      draw_text "Bill To,", :at => [320, 590], size: 9
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
         
      bounding_box([320, 580],:width => 220) do
        text "#{@bill.customer.name.titleize}", size:11, :style => :bold, :leading => 2
        text "#{@bill.customer.address.capitalize}", size: 9, :leading => 2
        text "#{@bill.customer.city.capitalize}", size: 9, :leading => 2
        #text "#{@bill.customer.pin_code}", size: 11, :leading => 3
        text "Phone  Number  :  #{@bill.customer.phone_number}", size: 9, :leading => 2
        text "Tin  Number        :  #{@bill.customer.tin_number}", size: 9, :leading => 2
      end
   end
     
   def bill_products
     [["Goods Description","Tax",  "Quantity", "Unit Price", "Total Price"]] + 
      @bill.line_items.map do|line_item|
        #qty for each item  
        qty = line_item.quantity
            if qty % 1 == 0.0
              qty = qty.to_i
            else
              qty = qty
            end
       #Tax Details         
        if line_item.bill_taxes.present? 
          line_item.bill_taxes.each do |tax|
           tax_type =  tax.tax.tax_type
             if tax_type == "Percentage" 
               @tax_name = tax.tax_type + "%" 
             elsif tax_type == "Flat Amount" 
               @tax_name = tax.tax_type + "( Flat Amount)"
             end 
            @tax_table = [@tax_name ]         
          end
        else
         " NA"
        end
        #product details
         if line_item.item_description.present?
           product_name = "#{line_item.product.product_name.titleize} \n #{item = line_item.item_description}"
        else
          product_name = line_item.product.product_name.titleize
        end
        [product_name, @tax_name, qty, "#{number_with_delimiter(line_item.unit_price,delimiter: ',')}", "#{number_with_delimiter(line_item.total_price.round(2), delimiter: ',')}"]
     end
   end
 
   def bill_table   
      bounding_box([5,500], :width => 550) do
        #move_down 30
         table bill_products do
           row(0).font_style = :bold
           columns(0..4).align = :center          
           self.header = true
           self.width = 500
            columns(0..5).size = 9
           columns(0).align = :left   
           column(1..2).align = :center
           column(3..5).align = :right
           columns(0..5).size = 9
            self.column(0).width = 145
           self.column(1).width = 110
           self.column(2).width = 65
           self.column(3).width = 90
           self.column(4).width = 90
           
         end
      end
   end
   
  
      

   def table_price_list
     move_down 5
     #bill total
     data =  [["Bill Total", "#{number_with_delimiter(@bill.total_bill_price.round(2), delimiter: ',')}"]]
     table(data,  :cell_style => {size:9, :inline_format => true, :align => :right},:column_widths => [160, 95], :position => 250)
     
      #Other charges like packing, transportation
      if @bill.bill_other_charges.present?
        @bill.bill_other_charges.each do |charges|
           charge = "#{charges.other_charges_information.other_charges}"
           data = [["#{charge}", "#{number_with_delimiter(charges.other_charges_amount, delimiter: ',')}"]]
           table(data, :cell_style => {size: 9, :inline_format => true, :align => :right},:column_widths => [160, 95], :position => 250)
        end
      end
      
      #Discount
      if @bill.discount.present?
         data = [[" Total Discount", "#{number_with_delimiter(@bill.discount)}"]]
         table(data, :cell_style => {size: 9, :inline_format => true, :align => :right}, :column_widths => [160, 95], :position => 250)
      end
      
      #Sub Total
       sub_total = @bill.total_bill_price.to_f + @bill.other_charges.to_f - @bill.discount.to_f
       data = [["Sub Total", "#{number_with_delimiter(sub_total.round(2), delimiter: ',')}"]]
       table(data, :cell_style => {size: 9, :inline_format => true, :font_style => :bold, :align => :right}, :column_widths => [160, 95], :position => 250)
         
        #Other Tax Details
           bill_taxes =  @bill.bill_taxes.where.not(:tax_name => ["VAT", "CST"])
           bill_taxes.each do |billtax|
              @tax_type = billtax.tax.tax_type 
           end 
           unique_taxes = bill_taxes.pluck(:tax_type).uniq 
           unique_taxes.each do |tax|
              tax_amount = bill_taxes.where(:tax_type => tax).sum(:tax_amount)
              if @tax_type == "Percentage"
                @tax_of_name = tax + " " + "%"
              elsif @tax_type == "Flat Amount"
                @tax_of_name  = tax + " " + "(Amount)" 
              end
           data = [["#{@tax_of_name}", "#{number_with_delimiter(tax_amount.round(2), delimiter: ',')}"]]
           table(data, :cell_style => {size: 9,  :align => :right}, :column_widths => [160, 95], :position => 250)
           end
           
       
           #VAT/CST details
           bill_taxes = @bill.bill_taxes.where(:tax_name => ["VAT", "CST"])
           bill_taxes.each do |billtax| 
              @tax_type = billtax.tax.tax_type
           end 
           unique_taxes = bill_taxes.pluck(:tax_type).uniq 
           unique_taxes.each do |tax| 
               tax_type = tax 
               tax_amount = bill_taxes.where(:tax_type => tax).sum(:tax_amount) 
               if @tax_type == "Percentage"
                 @tax_of_name1 = tax_type + " " + "%"
               elsif @tax_type == "Flat Amount"
                 @tax_of_name1 = tax_type + " "+ "(Amount) "
               end 
               data = [["#{@tax_of_name1}", "#{number_with_delimiter(tax_amount.round(2), delimiter: ',')}"]]
               table(data, :cell_style => {size: 9,  :align => :right}, :column_widths => [160, 95], :position => 250)
           end
                
          data = [["Grand Total", "#{number_with_delimiter(@bill.grand_total.round(2), delimiter: ',')}"]]
         table(data, :cell_style => {size: 9, :font_style => :bold, :inline_format => true, :align => :right}, :column_widths => [160, 95], :position => 250)
      end

      
   def authority
      move_down 20
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
         move_down 30
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
       move_down 80
       indent 10 do
           text "Terms and Conditions", size: 10, :style => :bold
           text "", size: 10
           text "1. Interest @ 24% per annum will be charged on the bills remaining unpaid after 15 days.", size: 9
           text "2. No claim will be entertained after goods are duly accepted.",  size: 9
           text "3. Goods once sold cannot be taken back or exchanged.", size: 9
           text "4. Subject to Bangalore Jurisdiction.",  size: 9
       end
   end
end  
   #def footer
    # options = {
     #   :at => [pdf.bounds.right - 150, 100],
      #  :width => 150,
       # :align => :right,
        #:start_count_at => 1
    # }
   #number_pages "Page <page> of <total>", options
    # repeat :all do
     #   bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      #    font "Helvetica"
       #   text "Here's My Fancy Header", :align => :center, :size => 25
        #  stroke_horizontal_rule
       # end
     #end
   #end


  
  #end
 
#def footer
 # move_down 70
  #indent 200 do
 #text "We Thank You for your Business", size: 12
#end


#end
#repeat :all do
#bounding_box([bounds.right - 59, bounds.bottom - -20], :width => 60, :height => 20) do

 # pagecount = page_count
  #text "Page #{pagecount}"
#end
#end
#end
#end
#string = "page <page> of <total>"
#options = { :at =>  [250, 0],
 # :start_count_at => 1}
#number_pages string, options
  
 
class BillPdfFour < Prawn::Document
  require 'prawn/table'
  require "open-uri"
  include ActionView::Helpers::NumberHelper
  
  
  def initialize(bill)
    super()
     @bill = bill
     @user = Authuser.find(@bill.authuser_id)
     logo(@user)
     bill_title
     bill_customer
     bill_products
     #subtable
     bill_table
     table_price_list
     authority   
   end


  def logo(user)
   #display logo
    role_name = @user.main_roles.pluck(:role_name)
    if role_name.include? "user"
      if @user.image.present?
         image open(@user.image_url), height: 70, width: 250, crop: "fit", :at => [150,710]
      else
         bounding_box([120,710], width: 250) do
          if @user.main_roles.first.role_name == "user"
            text "#{@bill.authuser.users.first.company.titleize}",size: 10, :style => :bold, :align => :center
          elsif @user.main_roles.first.role_name  == "secondary_user"
            primary_user_id = @user.invited_by_id
            text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 10, :style => :bold, :leading => 2
          elsif @user.main_roles.first.role_name  == "client"
            text "#{@bill.authuser.clients.first.company.titleize}",size: 10, :style => :bold , :align => :center
          end
         end
      end
    elsif @user.main_roles.first.role_name == "secondary_user"
     primary_user_id = @user.invited_by_id
      if Authuser.find(primary_user_id).image.present?
        image open(Authuser.find(primary_user_id).image_url), height: 70, width: 250, crop: "fit", :at => [150,710]
      else
       bounding_box([120,710], width: 250) do
         text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 10, :style => :bold, :align => :center
       end
      end
    end
   # to display company name and address
    role_name = @user.main_roles.pluck(:role_name)
   unless role_name.include? "secondary_user"
      bounding_box([130,630],:width =>320) do
        if @user.main_roles.first.role_name == "user"
          text "#{@bill.authuser.users.first.company.titleize}",size: 10, :style => :bold, align: :center, :leading => 2
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company.titleize}",size: 10, :style => :bold, align: :center, :leading => 2
        end 
        text "#{@bill.authuser.address.address_line_1.capitalize}, " + "#{@bill.authuser.address.address_line_2}, " + "#{@bill.authuser.address.address_line_3}", size: 9, align: :center, :leading => 2
        text "#{@bill.authuser.address.city.capitalize}", size: 9, align: :center, :leading => 2
        text "<font size=\"9\">Mobile Number :  #{@bill.authuser.membership.phone_number}</font> <font size=\"9\"> Tin Number :  #{@bill.authuser.users.first.tin_number}</font>", :inline_format => true, align: :center
      end
    else
      bounding_box([130,630],:width =>320) do
        primary_user_id = @bill.authuser.invited_by_id
        text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 9, :style => :bold, align: :center, :leading => 2
        text "#{Authuser.find(primary_user_id).address.address_line_1.capitalize}, " + "#{Authuser.find(primary_user_id).address.address_line_2}, " + "#{Authuser.find(primary_user_id).address.address_line_3}", size: 9, align: :center, :leading => 2
        text "#{Authuser.find(primary_user_id).address.city.capitalize}", size: 9, align: :center, :leading => 2
        text "<font size=\"9\">Mobile Number :  #{Authuser.find(primary_user_id).membership.phone_number}</font> <font size=\"9\"> Tin Number :  #{Authuser.find(primary_user_id).users.first.tin_number}</font>", :inline_format => true, align: :center
      end
    end
  end

      
   def bill_title    
      font "Times-Roman"
      bounding_box([225,560], :width => 100) do 
        text "<u>TAX INVOICE</u>", size: 11, :inline_format => true
        move_down 5
      end
        stroke_horizontal_rule
   end 
  
   def bill_customer
      draw_text "To,", :at => [10, 525], size: 9, :style => :bold
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
      bounding_box([10, 515],:width => 220) do
        text "#{@bill.customer.name.titleize}",size:9, :style => :bold, :leading => 2
        text "#{@bill.customer.address.capitalize}" , size: 9 , :leading => 2
        text "#{@bill.customer.city.capitalize}", size: 9, :leading => 2
        #text "#{@bill.customer.pin_code}", size: 11, :leading => 2
        text "Phone  Number   :  #{@bill.customer.phone_number}", size: 9, :inline_format => true
      end
      bounding_box([320, 515], :width => 300) do
        text "<b>Invoice Number        :</b>  #{@bill.invoice_number}" ,size:9, :inline_format => true, :leading => 2
        text "<b>Invoice Date              :</b>  #{@bill.bill_date.strftime("%b %d, %Y")}" ,size:9, :inline_format => true , :leading => 2
        text "<b>Tin Number              :</b>  #{@bill.customer.tin_number}", size: 9, :inline_format => true, :leading => 2
        if @bill.esugam == nil
          text "<b>e-Sugam Number     :</b>  NA", :inline_format => true, size: 9, :leading => 2
        else
          text "</b>e-Sugam Number  :</b>   #{@bill.esugam}", :inline_format=> true, size: 9, :leading => 2
        end
      end
      move_down 5
      stroke_horizontal_rule
   end
      
  
   def bill_products
      [["Goods Description", "Tax", "Quantity", "Unit Price", "Total Price"]] + 
      @bill.line_items.map do|line_item|
         qty = line_item.quantity
         if qty % 1 == 0.0
            qty = qty.to_i
         else
            qty = qty
         end
         #Tax Details         
        if line_item.bill_taxes.present? 
          taxes = line_item.bill_taxes.pluck(:tax_type_of_tax)
          @tax = taxes.to_sentence
        else
          @tax = "Nil"
        end
        #product details
         if line_item.item_description.present?
           product_name = "#{line_item.product.product_name.titleize} \n #{item = line_item.item_description}"
        else
          product_name = line_item.product.product_name.titleize
        end
        
       
        #[@tax_nmae]
        #@sub_table = make_table([[@tax_nmae]])
        #@sub_table = make_table([[@tax_nmae ]]) 
        #@sub_table = @tax_nmae #list only one tax
       # @sub_table = make_table([taxes]) # shows taxes in horizontal way
           
          #end
          
        [product_name, @tax, qty, "#{number_with_delimiter(line_item.unit_price,delimiter: ',')}", "#{number_with_delimiter(line_item.total_price.round(2), delimiter: ',')}"]
  #end
      end
   end
   
   def bill_table   
      bounding_box([25,450], :width => 530) do
      
        table bill_products do
           row(0).font_style = :bold
           columns(0..4).align = :center          
           self.header = true
           self.width = 465
           columns(0..4).size = 9
           columns(0).align = :left   
           column(1..2).align = :center
           column(3).align = :center
           column(4).align = :right
           columns(0..4).size = 9
           self.column(0).width = 145
           self.column(1).width = 110
           self.column(2).width = 65
           self.column(3).width = 70
           self.column(4).width = 75
           
         end
      end
   end
   
   def table_price_list
         data =  [["Bill Total", "#{number_with_delimiter(@bill.total_bill_price.round(2), delimiter: ',')}"]]
         table(data,  :cell_style => {size: 9, :inline_format => true, :align => :right},:column_widths => [390, 75], :position => 25)
        
          #Other charges like packing, transportation
          if @bill.bill_other_charges.present?
            @bill.bill_other_charges.each do |charges|
              charge = "#{charges.other_charges_information.other_charges}"
              data = [["#{charge}", "#{number_with_delimiter(charges.other_charges_amount, delimiter: ',')}"]]
              table(data, :cell_style => {size: 9, :inline_format => true, :align => :right},:column_widths => [390, 75], :position => 25)
            end
          end
          
          #Discount
          if @bill.discount.present?
             data = [[" Total Discount", "#{number_with_delimiter(@bill.discount)}"]]
             table(data, :cell_style => {size: 9, :inline_format => true, :align => :right}, :column_widths => [390, 75], :position => 25)
          end
          
          #Sub Total
           sub_total = @bill.total_bill_price.to_f + @bill.other_charges.to_f - @bill.discount.to_f
           data = [["Sub Total", "#{number_with_delimiter(sub_total.round(2), delimiter: ',')}"]]
           table(data, :cell_style => {size: 9, :font_style => :bold, :inline_format => true, :align => :right},:column_widths =>[390, 75], :position => 25)
         
           #Other Tax Details
           bill_taxes = @bill.bill_taxes.where.not(:tax_name => ["VAT", "CST"])
           unique_taxes = bill_taxes.pluck(:tax_type_of_tax).uniq 
           unique_taxes.each do |tax|
              tax_amount = bill_taxes.where(:tax_type_of_tax => tax).sum(:tax_amount)             
              @tax_of_name = tax      
              data = [["#{@tax_of_name}", "#{number_with_delimiter(tax_amount.round(2), delimiter: ',')}"]]
              table(data, :cell_style => {size: 9,  :align => :right}, :column_widths => [390, 75], :position => 25)
           end
           
       
           #VAT/CST details
           bill_taxes = @bill.bill_taxes.where(:tax_name => ["VAT", "CST"])
           unique_taxes = bill_taxes.pluck(:tax_type_of_tax).uniq 
           unique_taxes.each do |tax| 
               tax_type = tax 
               tax_amount = bill_taxes.where(:tax_type_of_tax => tax).sum(:tax_amount) 
             tax_on_tax = BillTax.where(:tax_type_of_tax => tax).first.tax.tax_on_tax
             if tax_on_tax == "yes"
               @tax_of_name = tax_type + " " + "(TOT)"
             else
               @tax_of_name = tax_type
             end
               data = [["#{@tax_of_name}", "#{number_with_delimiter(tax_amount.round(2), delimiter: ',')}"]]
               table(data, :cell_style => {size: 9,  :align => :right}, :column_widths => [390, 75], :position => 25)
           end
           
           data = [["Grand Total", "#{number_with_delimiter(@bill.grand_total.round(2), delimiter: ',')}"]]
           table(data, :cell_style => {size: 9, :font_style => :bold, :inline_format => true, :align => :right}, :column_widths => [390, 75], :position => 25)
            move_down 9
     
            text "<u><b>#{number_to_currency_in_words(@bill.grand_total, currency: :rupee).titleize} only</b></u>", size: 9, align: :right, :inline_format => true
     
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
           move_down 20
           text "Authorized Signatory",  size: 10, :style => :bold
        end
     else
        indent(350) do
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
          move_down 20
          text "Authorized Signatory",  size: 10, :style => :bold
        end
     end
   end
end # class ends 

  
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
  
 
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
      [["Goods Description", "Tax % (VAT/CST)", "Service Tax %", "Quantity", "Unit Price", "Total Price"]] + 
      @bill.line_items.map do|line_item|
           qty = line_item.quantity
            if qty % 1 == 0.0
              qty = qty.to_i
            else
              qty = qty
            end
           #tax for each item
          if line_item.tax_id.present?
           tax = line_item.tax.tax_rate
          else
           tax = 'NA'
          end
          #service tax for each item
          if line_item.service_tax_rate.present?
             service_tax = line_item.service_tax_rate
          else
            service_tax = "NA"
          end
        [line_item.product.product_name.titleize, tax, service_tax, qty, "#{number_with_delimiter(line_item.unit_price,delimiter: ',')}", "#{number_with_delimiter(line_item.total_price.round(2), delimiter: ',')}"]
      end
    end
 
   def bill_table   
      bounding_box([5,450], :width => 530) do
      
         table bill_products do
           row(0).font_style = :bold
           columns(0..4).align = :center          
           self.header = true
           self.width = 530
           columns(0..5).size = 9
           columns(0).align = :left   
           column(1..2).align = :center
           column(3..5).align = :right
           columns(0..5).size = 9
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
         data =  [["Bill Total", "#{number_with_delimiter(@bill.total_bill_price.round(2), delimiter: ',')}"]]
table(data,  :cell_style => {size: 9, :inline_format => true, :align => :right},:column_widths => [435, 95], :position => 5)
        
        #Other charges like packing, transportation
         if @bill.other_charges_information_id != nil
            data = [["#{@bill.other_charges_information.other_charges}", "#{number_with_delimiter(@bill.other_charges, delimiter: ',')}"]]
table(data, :cell_style => {size: 9, :inline_format => true, :align => :right},:column_widths => [435, 95], :position => 5)
         end
          #Discount
           if @bill.discount.present?
             data = [[" Total Discount", "#{number_with_delimiter(@bill.discount)}"]]
             table(data, :cell_style => {size: 9, :inline_format => true, :align => :right}, :column_widths => [435, 95], :position => 5)
           end
         #Sub Total
         sub_total = @bill.total_bill_price.to_f + @bill.other_charges.to_f - @bill.discount.to_f
         data = [["Sub Total", "#{number_with_delimiter(sub_total.round(2), delimiter: ',')}"]]
table(data, :cell_style => {size: 9, :font_style => :bold, :inline_format => true, :align => :right},:column_widths =>[435, 95], :position => 5)
         #Tax Details
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
            table(data, :cell_style => {size: 9, :inline_format => true, :align => :right}, :column_widths => [435, 95], :position => 5)
            end
          end
         end        
         #Service Tax Details
         service_tax = @bill.line_items.pluck(:service_tax_rate)
         if service_tax.present?
           service_tax = @bill.line_items.pluck(:service_tax_rate)
           service_tax_rates = @bill.line_items.map(&:service_tax_rate) 
           service_tax_rates = service_tax_rates.uniq 
           service_tax_rates.each do |service_tax| 
             if service_tax != nil
               line_items = @bill.line_items.where(:service_tax_rate => service_tax)
               line_items_total_price = line_items.sum(:total_price) 
               data = [["Service Tax Total @ #{service_tax} on #{line_items_total_price}", "#{((service_tax/100) * line_items_total_price).round(2)}"]]   
             table(data, :cell_style => {size: 9, :inline_format => true, :align => :right}, :column_widths => [435, 95], :position => 5)  
             end
           end 
        end

        data = [["Grand Total", "#{number_with_delimiter(@bill.grand_total.round(2), delimiter: ',')}"]]
        table(data, :cell_style => {size: 9, :font_style => :bold, :inline_format => true, :align => :right}, :column_widths => [435, 95], :position => 5)
         move_down 5
         text "<u><b>Rupees #{@bill.grand_total.round.to_words} only</b></u>", size: 9, align: :right, :inline_format => true
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
  
 
class BillPdfTwo < Prawn::Document
  require 'prawn/table'
  require "open-uri"
  include ActionView::Helpers::NumberHelper
  
  
   def initialize(bill)
    super()
     @bill = bill
     @user = Authuser.find(@bill.authuser_id)
     bill_title
     bill_line    
     bill_products
     bill_table
     table_price_list
     grand_total
   end


   
   def bill_title    
      font "Helvetica"
     draw_text "INVOICE", :at => [425,690],size: 15
      bounding_box([290,670],:width =>225) do
        if @user.main_roles.first.role_name == "user"
          text "#{@bill.authuser.users.first.company.titleize}",size: 9, :style => :bold, :align => :right, :leading => 2
        elsif @user.main_roles.first.role_name  == "secondary_user"
          primary_user_id = @user.invited_by_id
          text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 9, :style => :bold, :align => :right, :leading => 2
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company.titleize}",size: 9, :style => :bold, :align => :right, :leading => 3
        end 
      
        role_name = @user.main_roles.pluck(:role_name)
        unless role_name.include? "secondary_user"
          text "#{@bill.authuser.address.address_line_1.capitalize}, " + "#{@bill.authuser.address.address_line_2}, " + "#{@bill.authuser.address.address_line_3}", size: 9, :align => :right, :leading => 3
          text "#{@bill.authuser.address.city.capitalize}", size: 9, :align => :right, :leading => 3
          #text "Country :#{@bill.authuser.address.country}"
          text "Mobile Number   :   #{@bill.authuser.membership.phone_number}", size: 9, :align => :right, :leading => 3
          text "Tin Number        :   #{@bill.authuser.users.first.tin_number}", size: 9, :align => :right, :leading => 2
        else
           primary_user_id = @bill.authuser.invited_by_id
          text "#{Authuser.find(primary_user_id).address.address_line_1.capitalize}, " + "#{Authuser.find(primary_user_id).address.address_line_2}, " + "#{Authuser.find(primary_user_id).address.address_line_3}", size: 9, :align => :right, :leading => 3
          text "#{Authuser.find(primary_user_id).address.city.capitalize}", size: 9, :align => :right, :leading => 3
          #text "Country :#{@bill.authuser.address.country}"
          text "Mobile Number   :   #{Authuser.find(primary_user_id).membership.phone_number}", size: 9, :align => :right, :leading => 3
          text "Tin Number        :   #{Authuser.find(primary_user_id).users.first.tin_number}", size: 9, :align => :right, :leading => 2
        end
      end
   end
 
  
   def bill_line 
      move_down 5
      stroke_color '808080'
      stroke_horizontal_rule
       
      bounding_box([320, 585], :width => 210) do
        text "<b>Invoice Number     :</b>    #{@bill.invoice_number}" ,size:9, :inline_format => true, :leading => 5
        text "<b>Invoice Date           :</b>    #{@bill.bill_date.strftime("%b %d, %Y")}" ,size:9, :inline_format => true, :leading => 5
        if @bill.esugam == nil
          text "<b>e-Sugam Number  :</b>    NA", :inline_format => true, size: 9, :leading => 5
        else
          text "<b>e-Sugam Number  :</b>   #{@bill.esugam}", :inline_format=> true, size: 9, :leading => 5
        end
     text "<b>Amount due (INR)   :  </b> #{(@bill.grand_total.round(2))}" ,size:9, :inline_format => true
      end

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

        bounding_box([5, 585],:width => 200) do
          text "Bill To:" , size:9, :leading => 2
          text "#{@bill.customer.name.titleize}", size:10, :style => :bold, :leading => 3
          text "#{@bill.customer.address.capitalize}" , size: 9 , :leading => 3
          text "#{@bill.customer.city.capitalize}", size: 9, :leading => 3
         # text "#{@bill.customer.pin_code}", size: 11, :leading => 3
          text "Mobile Number   : #{@bill.customer.phone_number}", size: 9, :leading => 3
          text "Tin Number        : #{@bill.customer.tin_number}", size: 9, :leading => 3
        end
        move_down 10
        stroke_horizontal_rule      
   end
      
       
   def bill_products
     [["Goods Description","Tax %", "Service Tax %", "Quantity", "Unit Price", "Total Price"]] + 
       @bill.line_items.map do|line_item|
         #qty for each item
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
         #Product Details
         if line_item.item_description.present?
           product_name = "#{line_item.product.product_name.titleize} \n #{item = line_item.item_description}"
        else
          product_name = line_item.product.product_name.titleize
        end
         [product_name, tax, service_tax, qty, "#{number_with_delimiter(line_item.unit_price,delimiter: ',')}", "#{number_with_delimiter(line_item.total_price.round(2), delimiter: ',')}"]
      end
   end
 
   def bill_table   
      bounding_box([5,505], :width => 530) do
        move_down 25
         table bill_products do
           #border_color = "FF0FFF"
           row(0).font_style = :bold
           row(0).text_align = :center 
           columns(0..5).size = 9
           columns(0).align = :left   
           column(1..2).align = :center
           column(3..5).align = :right
           columns(0..5).size = 9
           self.header = true
           self.width = 530
           self.column(0).width = 145
           self.column(1).width = 65
           self.column(2).width = 65
           self.column(3).width = 70
           self.column(4).width = 90
           self.column(5).width = 95
           #cell_style: { border_color = "FFFFFF" },
           
         end
      end
   end
   
   def table_price_list
     move_down 5
     #bill total
         data =  [["Bill Total", "#{number_with_delimiter(@bill.total_bill_price.round(2), delimiter: ',')}"]]
table(data,  :cell_style => {size: 9, :inline_format => true, :align => :right},:column_widths => [160, 95], :position => 280)
        #Other charges like packing, transportation
       #Other charges like packing, transportation
         if @bill.other_charges_information_id != nil
            data = [["#{@bill.other_charges_information.other_charges}", "#{number_with_delimiter(@bill.other_charges, delimiter: ',')}"]]
table(data, :cell_style => {size: 9, :inline_format => true, :align => :right},:column_widths => [160, 95], :position => 280)
         end
            # discount row
           if @bill.discount.present?
             data = [[" Total Discount", "#{number_with_delimiter(@bill.discount)}"]]
table(data, :cell_style => {size: 9, :inline_format => true, :align => :right}, :column_widths => [160, 95], :position => 280)
           end

            # Sub total row
sub_total = @bill.total_bill_price.to_f + @bill.other_charges.to_f - @bill.discount.to_f
          data = [["Sub Total", "#{number_with_delimiter(sub_total.round(2), delimiter: ',')}"]]
table(data, :cell_style => {size: 9, :inline_format => true, :align => :right, :font_style => :bold, }, :column_widths => [160, 95], :position => 280)
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
            table(data, :cell_style => {size: 9, :inline_format => true, :align => :right}, :column_widths => [160, 95], :position => 280)
            end
          end
         end
        #service tax details
         service_tax = @bill.line_items.pluck(:service_tax_rate)
         if service_tax.present?
            service_tax = @bill.line_items.pluck(:service_tax_rate)
           service_tax_rates = @bill.line_items.map(&:service_tax_rate) 
           service_tax_rates = service_tax_rates.uniq 
           service_tax_rates.each do |service_tax| 
            if service_tax != nil
              line_items = @bill.line_items.where(:service_tax_rate => service_tax)
              line_items_total_price = line_items.sum(:total_price) 
              data = [["Service Tax @ #{service_tax} % on #{(line_items_total_price.round(2))}", "#{((service_tax/100) * line_items_total_price).round(2)}"]]   
           table(data, :cell_style => {size:9, :inline_format => true, :align => :right}, :column_widths => [160, 95], :position => 280)
            end 
           end 
         end
        #Total 
           data = [["Total", "#{number_with_delimiter(@bill.grand_total.round(2), delimiter: ',')}"]]
table(data, :cell_style => {size:9, :font_style => :bold, :inline_format => true, :align => :right}, :column_widths => [160, 95], :position => 280)
  

  def grand_total
    move_down 10
    indent 420 do
      text "Grand Total",size: 12
      move_down 10
       
       image "app/assets/images/rs symbol.png", :width => 12, :height => 12
      move_down 34
      grand_total = (@bill.grand_total).round(2)
      if grand_total.to_s.split(".")[1].length >= 2
       draw_text "#{grand_total.round(2)}", size: 12, :style => :bold, :at => [20, y.to_i]
      elsif grand_total.to_s.split(".")[1].length <  2
       draw_text "#{grand_total}0", size: 12, :style => :bold, :at => [20, y.to_i]
      end
    end
  end
end
end # class ends here 

  
 
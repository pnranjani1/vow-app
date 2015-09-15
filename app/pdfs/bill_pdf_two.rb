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
     draw_text "INVOICE", :at => [425,690],size: 18
      bounding_box([290,650],:width =>225) do
        if @user.main_roles.first.role_name == "user"
          text "#{@bill.authuser.users.first.company.titleize}",size: 12, :style => :bold, :align => :right, :leading => 3
        elsif @user.main_roles.first.role_name  == "secondary_user"
          primary_user_id = @user.invited_by_id
          text "#{Authuser.find(primary_user_id).users.first.company.titleize}",size: 12, :style => :bold, :align => :right, :leading => 3
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company.titleize}",size: 12, :style => :bold, :align => :right, :leading => 3
        end 
      
        role_name = @user.main_roles.pluck(:role_name)
        unless role_name.include? "secondary_user"
          text "#{@bill.authuser.address.address_line_1.capitalize}, " + "#{@bill.authuser.address.address_line_2}, " + "#{@bill.authuser.address.address_line_3}", size: 11, :align => :right, :leading => 3
          text "#{@bill.authuser.address.city.capitalize}", size: 11, :align => :right, :leading => 3
          #text "Country :#{@bill.authuser.address.country}"
          text "Mobile Number   :   #{@bill.authuser.membership.phone_number}", size: 11, :align => :right, :leading => 3
          text "Tin Number        :   #{@bill.authuser.users.first.tin_number}", size: 11, :align => :right, :leading => 2
        else
           primary_user_id = @bill.authuser.invited_by_id
          text "#{Authuser.find(primary_user_id).address.address_line_1.capitalize}, " + "#{Authuser.find(primary_user_id).address.address_line_2}, " + "#{Authuser.find(primary_user_id).address.address_line_3}", size: 11, :align => :right, :leading => 3
          text "#{Authuser.find(primary_user_id).address.city.capitalize}", size: 11, :align => :right, :leading => 3
          #text "Country :#{@bill.authuser.address.country}"
          text "Mobile Number   :   #{Authuser.find(primary_user_id).membership.phone_number}", size: 11, :align => :right, :leading => 3
          text "Tin Number        :   #{Authuser.find(primary_user_id).users.first.tin_number}", size: 11, :align => :right, :leading => 2
        end
      end
   end
 
  
   def bill_line 
      move_down 20
      stroke_color '808080'
      stroke_horizontal_rule
       
      bounding_box([320, 520], :width => 210) do
        text "<b>Invoice Number     :</b>    #{@bill.invoice_number}" ,size:11, :inline_format => true, :leading => 5
        text "<b>Invoice Date           :</b>    #{@bill.bill_date.strftime("%b %d, %Y")}" ,size:11, :inline_format => true, :leading => 5
        if @bill.esugam == nil
            text "<b>E-Sugam Number  :</b>    NA", :inline_format => true, size: 11, :leading => 5
        else
           text "<b>E-Sugam Number  :</b>   #{@bill.esugam}", :inline_format=> true, size: 11, :leading => 5
        end
     text "<b>Amount due (INR)   :  </b> #{(@bill.grand_total+ @bill.line_items.sum(:service_tax_amount)).round(2)}" ,size:11, :inline_format => true
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

        bounding_box([30, 530],:width => 200) do
          text "Bill To:" , size:12, :leading => 2
          text "#{@bill.customer.name.titleize}", size:12, :style => :bold, :leading => 3
          text "#{@bill.customer.address.capitalize}" , size: 11 , :leading => 3
          text "#{@bill.customer.city.capitalize}", size: 11, :leading => 3
         # text "#{@bill.customer.pin_code}", size: 11, :leading => 3
          text "Mobile Number   : #{@bill.customer.phone_number}", size: 11, :leading => 3
          text "Tin Number        : #{@bill.customer.tin_number}", size: 11, :leading => 3
        end
        move_down 10
        stroke_horizontal_rule      
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
      bounding_box([5,400], :width => 550) do
        move_down 30
         table bill_products do
           #border_color = "FF0FFF"
           row(0).font_style = :bold
           columns(0..4).align = :center          
           self.header = true
           self.width = 530
           self.column(0).width = 135
           self.column(1).width = 100
           self.column(2).width = 100
           self.column(3).width = 115
           self.column(4).width = 80
           #cell_style: { border_color = "FFFFFF" },
           
         end
      end
   end
   
   def table_price_list
     move_down 10
         data =  [["<b>Bill Total</b>", "#{number_with_delimiter(@bill.total_bill_price.round(2), delimiter: ',')}"]]
table(data,  :cell_style => {:inline_format => true, :align => :right, :border_color => "FFFFFF"},:column_widths => [125, 110], :position => 300)
        
         if @bill.other_charges_information_id != nil
            data = [["<b>#{@bill.other_charges_information.other_charges}</b>", "#{number_with_delimiter(@bill.other_charges, delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :right, :border_color => "FFFFFF"},:column_widths =>[125, 110], :position => 300)
         elsif @bill.other_charges_information_id == nil
           data = [["<b>Other Charges</b>", "NA"]]
table(data, :cell_style => {:inline_format => true, :align => :right, :border_color => "FFFFFF"},:column_widths =>[125, 110], :position => 300)
         end

          sub_total = @bill.total_bill_price.to_f + @bill.other_charges.to_f
          data = [["<b>Sub Total</b>", "#{number_with_delimiter(sub_total.round(2), delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :right, :border_color => "FFFFFF"}, :column_widths => [125, 110], :position => 300)
          
         if @bill.other_charges != nil     
           total = @bill.total_bill_price + @bill.other_charges
           data = [["<b>#{@bill.tax.tax} on #{number_with_delimiter(total.round(2), delimiter: ',')}</b>", "#{number_with_delimiter((@bill.tax.tax_rate*0.01* total).round(2), delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :right, :border_color => "FFFFFF"},:column_widths => [125, 110], :position => 300)
         else 
            total = @bill.total_bill_price 
            data = [["<b>#{@bill.tax.tax} on #{number_with_delimiter(total, delimiter: ',')}</b>", "#{(@bill.tax.tax_rate*0.01* total).round(2)}"]]
table(data, :cell_style => {:inline_format => true, :align => :right, :border_color => "FFFFFF"},:column_widths => [125, 110], :position => 300)    
         end

          service_tax = @bill.line_items.pluck(:service_tax_rate)
         if service_tax.present?
            service_tax = @bill.line_items.pluck(:service_tax_rate)
           service_tax_rates = @bill.line_items.map(&:service_tax_rate) 
           service_tax_rates = service_tax_rates.uniq 
           service_tax_rates.each do |service_tax| 
             line_items = @bill.line_items.where(:service_tax_rate => service_tax)
             line_items_total_price = line_items.sum(:total_price) 
             data = [["<b> Service Tax Total @ #{service_tax}</b>", "#{((service_tax/100) * line_items_total_price).round(2)}"]]   
           table(data, :cell_style => {:inline_format => true, :align => :right, :border_color => "FFFFFF"}, :column_widths => [143, 110], :position => 280)
           end 
         
           data = [["<b>Service Tax Amount </b>", "#{number_with_delimiter(@bill.line_items.sum(:service_tax_amount).round(2), delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :right, :border_color => "FFFFFF"}, :column_widths => [125, 110], :position => 300)
         end
             
            data = [["<b>Total</b>", "#{number_with_delimiter((@bill.grand_total + @bill.line_items.sum(:service_tax_amount)).round(2), delimiter: ',')}"]]
            table(data, :cell_style => {:inline_format => true, :align => :right, :border_color => "FFFFFF"}, :column_widths => [125, 110], :position => 300)
   end

  def grand_total
    move_down 20
    indent 380 do
      text "Grand Total",size: 19
      move_down 10
       
       image "app/assets/images/rs symbol.png", :width => 15, :height => 15
      move_down 34
      grand_total = (@bill.grand_total + @bill.line_items.sum(:service_tax_amount))
      if grand_total.to_s.split(".")[1].length >= 2
       draw_text "#{grand_total.round(2)}", size: 21, :style => :bold, :at => [20, y.to_i]
      elsif grand_total.to_s.split(".")[1].length <  2
       draw_text "#{grand_total}0", size: 21, :style => :bold, :at => [20, y.to_i]
      end
    end
  end

end # class ends here 

  
 
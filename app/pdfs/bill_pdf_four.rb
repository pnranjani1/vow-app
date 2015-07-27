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
   if @user.image.present?
         image open(@user.image_url), height: 70, width: 250, crop: "fit", :at => [150,710]
   else
         if @user.main_roles.first.role_name == "user"
           draw_text "#{@bill.authuser.users.first.company.titleize}",size: 14, :style => :bold, :at => [150,710]
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company.titleize}",size: 14, :style => :bold :at => [150,710]
        end 
   end
      bounding_box([130,630],:width =>320) do
        if @user.main_roles.first.role_name == "user"
          text "#{@bill.authuser.users.first.company.titleize}",size: 14, :style => :bold, align: :center
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company.titleize}",size: 14, :style => :bold, align: :center
        end 
        text "#{@bill.authuser.address.address_line_1.capitalize}, " + "#{@bill.authuser.address.address_line_2}, " + "#{@bill.authuser.address.address_line_3}", size: 11, align: :center
        text "#{@bill.authuser.address.city.capitalize}", size: 11, align: :center
            text "<font size=\"11\">Mobile Number :  #{@bill.authuser.membership.phone_number}</font> <font size=\"11\"> Tin Number :  #{@bill.authuser.users.first.tin_number}</font>", :inline_format => true
      end
   #  stroke_horizontal_rule
 end
      
   def bill_title    
      font "Times-Roman"
      bounding_box([225,510], :width => 100) do 
        text "<u>TAX INVOICE</u>", size: 11, :inline_format => true
        move_down 5
      end
        stroke_horizontal_rule
   end 
  
   def bill_customer
       draw_text "To,", :at => [10, 460], size: 11, :style => :bold
        bounding_box([10, 450],:width => 220) do
          text "#{@bill.customer.name.titleize}",size:11, :style => :bold
          text "#{@bill.customer.address.capitalize}" , size: 11 
          text "#{@bill.customer.city.capitalize}", size: 11
          text "#{@bill.customer.pin_code}", size: 11
          text "<b>Phone  Number   :</b>  #{@bill.customer.phone_number}", size: 11, :inline_format => true
        end
    
     
       bounding_box([320, 450], :width => 300) do
        text "<b>Invoice Number        :</b>  #{@bill.invoice_number}" ,size:11, :inline_format => true, :leading => 2
        text "<b>Invoice Date              :</b>  #{@bill.bill_date.strftime("%b %d, %Y")}" ,size:11, :inline_format => true , :leading => 2
        text "<b>Tin Number              :</b>  #{@bill.customer.tin_number}", size: 11, :inline_format => true, :leading => 2
        if @bill.esugam == nil
          text "<b>E-Sugam Number     :</b>  NA", :inline_format => true, size: 11, :leading => 2
        else
          text "</b>E-Sugam Number  :</b>   #{@bill.esugam}", :inline_format=> true, size: 11, :leading => 2
        end
       end
    move_down 25
    stroke_horizontal_rule
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
      bounding_box([5,380], :width => 550) do
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
         data =  [["<b>Bill Total</b>", "#{number_with_delimiter(@bill.total_bill_price.round(2), delimiter: ',')}"]]
table(data,  :cell_style => {:inline_format => true, :align => :right},:column_widths => [420, 110], :position => 5)
        
         if @bill.other_charges_information_id != nil
            data = [["<b>#{@bill.other_charges_information.other_charges}</b>", "#{number_with_delimiter(@bill.other_charges, delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :right},:column_widths =>[420, 110], :position => 5)
         elsif @bill.other_charges_information_id == nil
           data = [["<b>Other Charges</b>", "NA"]]
table(data, :cell_style => {:inline_format => true, :align => :right},:column_widths =>[420, 110], :position => 5)
         end
          
         if @bill.other_charges != nil     
           total = @bill.total_bill_price + @bill.other_charges
           data = [["<b>#{@bill.tax.tax} on #{number_with_delimiter(total.round(2), delimiter: ',')}</b>", "#{number_with_delimiter((@bill.tax.tax_rate*0.01* total).round(2), delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :right},:column_widths => [420, 110], :position => 5)
         else 
            total = @bill.total_bill_price 
            data = [["<b>#{@bill.tax.tax} on #{number_with_delimiter(total, delimiter: ',')}</b>", "#{(@bill.tax.tax_rate*0.01* total).round(2)}"]]
table(data, :cell_style => {:inline_format => true, :align => :right},:column_widths => [420, 110], :position => 5)    
         end


         data = [["<b>Grand Total</b>", "#{number_with_delimiter(@bill.grand_total.round(2), delimiter: ',')}"]]
table(data, :cell_style => {:inline_format => true, :align => :right}, :column_widths => [420, 110], :position => 5)
        move_down 10
        text "<u><b>Rupees #{@bill.grand_total.round.to_words} only</b></u>", size: 12, align: :right, :inline_format => true

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
  
 
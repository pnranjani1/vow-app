class BillPdf < Prawn::Document
  require 'prawn/table'
  
   def initialize(bill)
    super()
     @bill = bill
     @user = Authuser.find(@bill.authuser_id)
     bill_title
     bill_invoice_number
     bill_user
     bill_customer
     bill_table
     bill_products
     bill_total_bill_price
     bill_tax
     bill_grand_total
     end
  
  
    def bill_title      
      draw_text "Invoice", :at => [225,705],size: 22
      #if @bill.bill_date == nil
      # @bill.bill_date = Date.today
     #end
    draw_text @bill.bill_date.strftime("%b %d, %Y") ,:at => [400,670],size:12
    end
  
     def bill_invoice_number
       draw_text "Invoice number : #{@bill.invoice_number}", :at => [30, 670], size: 18
     end
  
      def bill_user   
      bounding_box([20,625],:width =>300) do
      text "Name : #{@bill.authuser.name.capitalize}",size: 18
      text "Address: #{@bill.authuser.address.address_line_3}"
      text "City :#{@bill.authuser.address.city}"
      text "Country :#{@bill.authuser.address.country}"
      text "Phone Number :#{@bill.authuser.membership.phone_number}"
      text "Tin Number :#{@bill.authuser.users.first.tin_number}"
    end
    
    def bill_customer
      bounding_box([280, 625],:width => 300) do
      text "Customer : #{@bill.customer.name}", size:18
      text "Address : #{@bill.customer.address}", size: 12
      text "City : #{@bill.customer.city}", size: 12
      text "Phone Number : #{@bill.customer.phone_number}", size: 12
      text "Tin Number : #{@bill.customer.tin_number}", size: 12
    end
    

      def bill_table   
    move_down 40
        table bill_products do
       row(0).font_style = :bold
        #  row(0).row_color =  :FFFFFF
          columns(0..3).align = :center
      #self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
          self.width = 500
          self.column(0).width = 125
          self.column(1).width = 75
          self.column(0).width = 150
          
    end
  end

      def bill_products
        [["Products","Quantity", "Unit Price", "Total Price"]] + 
        @bill.line_items.map do|line_item|
          [line_item.product.product_name, line_item.quantity, line_item.unit_price, line_item.total_price]
        end
      end
      
      def bill_total_bill_price
        move_down 40
        draw_text "Bill Total : #{@bill.total_bill_price}", :at => [315, 350], size: 20 
        draw_text "#{@bill.other_charges_info} : #{@bill.other_charges}" , :at => [315, 315], size: 20
      end
     
              
      def bill_tax
        total = @bill.total_bill_price + @bill.other_charges
        draw_text "#{@bill.tax.tax} on #{total} = #{@bill.tax.tax_rate*0.01* total}", :at => [315, 280], size: 20
      end
      
      def bill_grand_total
        draw_text "Grand Total : #{@bill.grand_total}", :at => [315, 240], size: 20
      end
      
     
      
  end
  end
end
  
  
  
 
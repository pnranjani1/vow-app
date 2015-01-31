class BillPdf < Prawn::Document
  require 'prawn/table'
  
   def initialize(bill)
    super()
     @bill = bill
     @user = Authuser.find(@bill.authuser_id)
     bill_title
     bill_user
     bill_customer
     bill_table
     bill_products
     table_price_list
     footer
    
    end
  
  
    def bill_title      
      draw_text "Invoice", :at => [225,705],size: 22
      #if @bill.bill_date == nil
      # @bill.bill_date = Date.today
     #end
   
    draw_text "Invoice Number : #{@bill.invoice_number}" ,:at => [400,670],size:12
      draw_text "Invoice Date: #{@bill.bill_date.strftime("%b %d, %Y")}" ,:at => [400,650],size:12
    end
  
     
      def bill_user   
        
      draw_text "Company Details", :at => [30,670], size:15
      bounding_box([30,660],:width =>300) do
      text "#{@bill.authuser.name}",size: 12
      text "Address: #{@bill.authuser.address.address_line_3}"
      text "City :#{@bill.authuser.address.city}"
      text "Country :#{@bill.authuser.address.country}"
      text "Phone Number :#{@bill.authuser.membership.phone_number}"
      text "Tin Number :#{@bill.authuser.users.first.tin_number}"
    end
    
     
  
    def bill_customer
      draw_text "Billing Name", :at => [30, 550], size: 15
      bounding_box([30, 545],:width => 300) do
      text "#{@bill.customer.name}", size:12
      text "Address : #{@bill.customer.address}", size: 12
      text "City : #{@bill.customer.city}", size: 12
      text "Phone Number : #{@bill.customer.phone_number}", size: 12
      text "Tin Number : #{@bill.customer.tin_number}", size: 12
    end
    
        def bill_table   
        move_down 40
        table bill_products do
        row(0).font_style = :bold
        row(0).background_color = '778899'   
        #  row(0).row_color =  :FFFFFF
         # row(0).row_color = "FF0000"
          columns(0..3).align = :center
      #self.row_colors = ["FFFFFF", "DDDDDD"]
        #self.row_colors = ["FFFFFF", "D3D3D3"]
      self.header = true
          self.width = 500
          self.column(0).width = 120
          self.column(1).width = 75
          self.column(2).width = 100
          self.column(2).width = 100
         end
  end


      def bill_products
        [["Products","Quantity", "Unit Price", "Total Price"]] + 
        @bill.line_items.map do|line_item|
          [line_item.product.product_name, line_item.quantity, line_item.unit_price, line_item.total_price]
        end
      end
      

   def table_price_list
 data =  [["Bill Total", "#{@bill.total_bill_price}"]]
table(data,  :cell_style => {:font_style => :bold},:column_widths => [140, 65], :position => 295)
        
 data = [["#{@bill.other_charges_info}", "#{@bill.other_charges}"]]
 table(data, :cell_style => {:font_style => :bold},:column_widths =>[140, 65], :position => 295)
        
 total = @bill.total_bill_price + @bill.other_charges
     data = [["#{@bill.tax.tax} on #{total}", "#{(@bill.tax.tax_rate*0.01* total).round(2)}"]]
 table(data, :cell_style => {:font_style => :bold},:column_widths => [140, 65], :position => 295)
        
 data = [["Grand Total", "#{@bill.grand_total}"]]
 table(data, :cell_style => {:font_style => :bold}, :column_widths => [140, 65], :position => 295)
 end
      
def footer
  draw_text "We Thank You for your Business ", :at => [180, 10], size: 12
end
      
end

string = "page <page> of <total>"
options = { :at =>  [250, 0],
  :start_count_at => 1}
number_pages string, options

end
end
  
  
  
 
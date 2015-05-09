class BillPdf < Prawn::Document
  require 'prawn/table'
  require "open-uri"
  
  
   def initialize(bill)
    super()
     @bill = bill
     @user = Authuser.find(@bill.authuser_id)
     stroke_bounds

     bill_title
     bill_user
     logo(@user)
     bill_customer
     bill_transport
     bill_table
     bill_products
     table_price_list
     authority
     terms_and_conditions
     #footer
     stroke_bounds 
    end


 # :margin => [10, 20, 30, 40]
      
    def bill_title      
      draw_text "INVOICE", :at => [225,690],size: 22
      #if @bill.bill_date == nil
      # @bill.bill_date = Date.today
     #end
   
    draw_text "Invoice Number : #{@bill.invoice_number}" ,:at => [320,670],size:12
      draw_text "Invoice Date      : #{@bill.bill_date.strftime("%b %d, %Y")}" ,:at => [320,650],size:12
  if @bill.esugam == nil
  draw_text "E-sugam Number: NA", :at => [8,640], size: 12
  else
  draw_text "E-sugam Number: #{@bill.esugam}", :at => [8,640], size: 12
    end
end
  
    def bill_user   
        
      draw_text "Company Details", :at => [8,620], size:15
      bounding_box([8,610],:width =>300) do
        if @user.main_roles.first.role_name == "user"
        text "#{@bill.authuser.users.first.company}",size: 12, :style => :bold
        elsif @user.main_roles.first.role_name  == "client"
          text "#{@bill.authuser.clients.first.company}",size: 12, :style => :bold
        end
      text "Address            :   #{@bill.authuser.address.address_line_3}"
      text "City                   :   #{@bill.authuser.address.city}"
      #text "Country :#{@bill.authuser.address.country}"
      text "Phone Number :   #{@bill.authuser.membership.phone_number}"
      text "Tin Number       :   #{@bill.authuser.users.first.tin_number}"
    end
    
     def logo(user)
       if @user.image.present?
       image open(@user.image_url), height: 50, width: 70, crop: "fit", :at => [10,710]
       end
     # gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      #size = 50
      #gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}?s=#{size}"+".jpg"
      #image open(gravatar_url), :at => [10,710]
     end
     
  
    def bill_customer
      draw_text "Billing Name", :at => [320, 620], size: 15
      bounding_box([320, 610],:width => 300) do
        text "#{@bill.customer.name}", size:12, :style => :bold
      text "Address            :   #{@bill.customer.address}", size: 12
      text "City                   :   #{@bill.customer.city}", size: 12
      text "Phone Number :   #{@bill.customer.phone_number}", size: 12
      text "Tin Number       :   #{@bill.customer.tin_number}", size: 12
    end
      move_down 10
      stroke_horizontal_rule
      
       
      def bill_transport   
        
        if @bill.transporter_name == ""
          draw_text "Goods Through : NA" , :style => :bold, :at => [30, 510], size: 11
        else
        draw_text "Goods Through : #{@bill.transporter_name}" , :style => :bold, :at => [30, 510], size: 11
        end
        if @bill.gc_lr_number == ""
        draw_text "LR Number : NA" , :style => :bold, :at => [280, 510] , size: 11
        else
          draw_text "LR Number : #{@bill.gc_lr_number} " , :style => :bold, :at => [280, 510], size: 11
        end
        if @bill.vechicle_number == ""
          draw_text "Vehicle Number : NA" , :style => :bold, :at => [30, 490], size: 11
        else
          draw_text "Vehicle Number : #{@bill.vechicle_number} " , :style => :bold, :at => [30, 490], size: 11
        end
        if @bill.lr_date == nil
          draw_text "LR Date       : NA" , :style => :bold, :at => [280, 490], size: 11
        else
          draw_text "LR Date       : #{@bill.lr_date.strftime("%d %b %Y")} " , :style => :bold, :at => [280, 490], size: 11
        end
        
      end
              
 
      bounding_box([30,810], :width => 550, :height => 320) do
      
        def bill_table   
        move_down 30
        table bill_products do
        row(0).font_style = :bold
        row(0).background_color = '778899'   
        #  row(0).row_color =  :FFFFFF
         # row(0).row_color = "FF0000"
          columns(0..3).align = :center
      #self.row_colors = ["FFFFFF", "DDDDDD"]
        #self.row_colors = ["FFFFFF", "D3D3D3"]
      self.header = true
          self.width = 530
          self.column(0).width = 120
          self.column(1).width = 75
          self.column(2).width = 115
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
table(data,  :cell_style => {:font_style => :bold},:column_widths => [125, 110], :position => 295)
        
     if @bill.other_charges_information_id != nil
       data = [["#{@bill.other_charges_information.other_charges}", "#{@bill.other_charges}"]]
 table(data, :cell_style => {:font_style => :bold},:column_widths =>[125, 110], :position => 295)
     elsif @bill.other_charges_information_id == nil
       data = [["Other Charges", "NA"]]
 table(data, :cell_style => {:font_style => :bold},:column_widths =>[140, 65], :position => 295)
     end
          
     if @bill.other_charges != nil     
 total = @bill.total_bill_price + @bill.other_charges
     data = [["#{@bill.tax.tax} on #{total}", "#{(@bill.tax.tax_rate*0.01* total).round(2)}"]]
 table(data, :cell_style => {:font_style => :bold},:column_widths => [125, 110], :position => 295)
   else 
    total = @bill.total_bill_price 
     data = [["#{@bill.tax.tax} on #{total}", "#{(@bill.tax.tax_rate*0.01* total).round(2)}"]]
 table(data, :cell_style => {:font_style => :bold},:column_widths => [125, 110], :position => 295)    
    end


 data = [["Grand Total", "#{@bill.grand_total}"]]
 table(data, :cell_style => {:font_style => :bold}, :column_widths => [125, 110], :position => 295)

data = [["Amount in words", "Rupees #{@bill.grand_total.round.to_words} only"]]
table(data, :cell_style => {:font_style => :bold, :align => :center}, :column_widths => [140, 390])
        end

      
 def authority
  move_down 40
   company = @bill.authuser.users.first.company
    if company.length >= 25
  indent(300) do
   if @user.main_roles.first.role_name == "user"
    text "For "+@bill.authuser.users.first.company,  size: 11, :style => :bold
     #text "For iPrimitus Consultancy Services", size: 11, style: :bold
   elsif @user.main_roles.first.role_name  == "client"
     text "For "+@bill.authuser.clients.first.company,  size: 11, :style => :bold
   end
  move_down 30
  text "Authorized Signatory",  size: 11, :style => :bold
end
 else
   indent(350) do
   if @user.main_roles.first.role_name == "user"
    text "For "+@bill.authuser.users.first.company,  size: 11, :style => :bold
    # text "For iPrimitus Consultancy Services", size: 11, style: :bold
   elsif @user.main_roles.first.role_name  == "client"
     text "For "+@bill.authuser.clients.first.company,  size: 11, :style => :bold
   end
  move_down 30
  text "Authorized Signatory",  size: 11, :style => :bold
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
 #:at => [110, 65], :width => 80, :size => 8
end
end


end
 
#def footer
 # move_down 70
 # indent 200 do
 #text "We Thank You for your Business", size: 12
#end
#end

end
end
     

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

 repeat :all do
      #Create a bounding box and move it up 18 units from the bottom boundry of the page
      bounding_box [bounds.left, bounds.bottom + 18], width: bounds.width do
        text "We Thank You for Your Business", size: 10, align: :center
      end
    end

end
end
  
  
  
 
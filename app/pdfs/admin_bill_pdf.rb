class AdminBillPdf < Prawn::Document
  require 'prawn/table'
 
  
   
  def initialize(user)
    super()
    @user = user
    stroke_bounds
    bill_title
    invoice_details
    logo
    bill_user
    bill_table
    amount_words
    #authority
    bank_details
    contact
   end
     
  def bill_title
    font 'Helvetica'
    draw_text "INVOICE", :at => [225,650],size: 18
    draw_text "Date:  #{Date.today.strftime( "%B %d, %Y")}", :at => [40, 570], size: 12
    #draw_text "Bill for : #{Date.today.strftime("%B %Y")}" ,:at => [350,670],size:12
  end

  def invoice_details
  draw_text 'Invoice#'"#{Date.today.strftime("%Y%m%d")}-VOW", :at => [350, 570], size: 12
draw_text "Ref: Professional Services", :at => [350, 550], size: 12
  end

   def logo
    filename = "app/assets/images/iprimitus.jpg"
    image filename, at: [10,710], width: 120, height: 110
   end

   def  bill_user
   #  draw_text "Chartered Accountant", at: [350,630], size: 14, :style => :bold
     bounding_box([40,550],:width =>300) do
       text "<u>To:</u>", size: 12, :inline_format => true
       move_down 10
       text "#{@user.name},", size: 12 
          if @user.clients.first.company.present?
             text "#{@user.clients.first.company},", size: 12
          end
        text "#{@user.address.address_line_1},", size: 12
        text "#{@user.address.address_line_2},", size: 12
        text "#{@user.address.city}", size: 12
       end
  end


 def bill_table 
  total_bills = Bill.where('created_at >= ? AND created_at <= ? AND client_id = ?', Date.today.beginning_of_month, Date.today.end_of_month, @user.id).count
  amount  = total_bills * 1
  bounding_box([30, 450], width: 580) do 
    data =  ([ ["Sl.No", "Particulars", "Total Bills", "Currency", "Amount"],
    ["1", "Professional Services Vatonwheels.com", total_bills, "INR", amount]
    ])
     move_down 20
    table(data) do
      row(0).font_style = :bold
      row(0).size = 11
      row(0).background_color = '778899'
      columns(0..4).align = :center
      self.header = true
      self.width = 470
      self.column(0).width = 50
      self.column(1).width = 180
      self.column(2).width = 80
      self.column(3).width = 80
      self.column(4).width = 80
    end   
    data = ([ ["Total", amount.to_s+".00"] ])
    table(data) do
      self.column(0).width = 390
      self.column(1).width = 80
      self.column(0).align = :right
      self.column(0..1).font_style = :bold
      self.column(1).align = :center
     end
   end 
end

  def amount_words
    indent 210 do
       total_bills = Bill.where('created_at >= ? AND created_at <= ? AND client_id = ?', Date.today.beginning_of_month, Date.today.end_of_month, @user.id).count
  amount  = total_bills * 1
      move_down 5
      text "(Rupees #{amount.to_words.capitalize} only)", :align => :center
   end
 end

#def authority
#  move_down 40
 # indent 300 do
 #   text " For iPrimitus Consultancy Services LLP"
  #  move_down 30
   # text " Authorized signatory"
  #end
#end

  def bank_details
    move_down 110
    indent 20 do
      text "<u>Bank Details</u>", size: 12, :inline_format => true
      text "Beneficiary A/c: iPrimitus Consultancy Services LLP", size:11
      text "A/c No: <b>913020026884292</b>", size: 11, :inline_format => true
      text "Bank and Branch: AXIS Bank Ltd., COX TOWN Branch, Bangalore[KT]", size: 11
      text "IFS Code: UTIB0000231", size: 11
      text "SWIFT Code: AXISINBB114",  size: 11
    end
  end


  def contact
    stroke_rectangle [20,110], 400, 60
    text_box "Payment is due immediate.", :at => [25, 100],  size: 10
    text_box "If you have any questions concerning this invoice, contact us.", :at => [25, 90], size: 10
    text_box "Phone: 91 80 41123752", size: 10, :at => [25, 80]
    text_box " Email: <u>support@vatonwheels.com</u>", size: 10, :at => [25, 70], :inline_format => true
 

    repeat :all do
      #Create a bounding box and move it up 18 units from the bottom boundry of the page
      bounding_box [bounds.left, bounds.bottom + 18], width: bounds.width do
        text "This is a computer generated invoice and requires no signature", size: 10, align: :center
      end
   end
  
end
     

end
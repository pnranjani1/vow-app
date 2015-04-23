class ReferralBillPdf < Prawn::Document
  require 'prawn/table'
  
  
  def initialize(referral)
    super()
    @referral = referral
    stroke_bounds
    bill_title
    logo
    referral_name
    ca_detail_table
    bank_details
    contact
  end
  
  def bill_title
    font "Times-Roman"
    draw_text "INVOICE", :at => [225,670], size: 18
    draw_text "Bill Date : #{Date.today.strftime("%d %b, %Y")}", :at => [350, 640], size: 12
  end


  def logo
    filename = "app/assets/images/iprimitus.jpg"
    image filename, :at => [10,710], width: 120, height: 110
  end

  def referral_name
        bounding_box([50, 570], :width => 300) do
         text "<u>To:</u>", size: 12, inline_format: true
           move_down 10
          indent 10 do
           text "#{@referral.name}", size: 12
           text "#{@referral.address_line_1}", size: 12
           text "#{@referral.address_line_2}", size: 12
           text "#{@referral.state}", size: 12
           text "#{@referral.mobile_number}", size: 12
        end
      end
    #stroke_horizontal_rule
  end
  
  def ca_detail_table
    move_down 30
    indent 40 do
      clients = Client.where('referral_id = ? AND created_at >= ? AND created_at <= ?', @referral.id, Date.today.beginning_of_month, Date.today.end_of_month )
      data = [["Sl.No", "Name of the CA", "No Of Users", "No Of Bills"]]
        clients.each_with_index do |client, index|
          index = index +1
          users = User.where(:client_id => client.authuser.id)
          bills = Bill.where(:client_id => client.authuser.id)
          value =  [index, client.authuser.name, users.count, bills.count]
          data += [value]
         end
      text "<b>No Of Chartered Accountants Referred in #{Date.today.strftime("%B")}:</b> #{clients.count}", size: 12, inline_format: true
      move_down 10
      
       table(data) do
         self.header = true
         self.column(0).width = 50
         self.column(1).width = 200
         self.column(2).width = 100
         self.column(3).width = 100
         self.column(0..3).align = :center
         row(0).font_style = :bold
         row(0).font_size = 11
         row(0).background_color = "778899"
       end
    end
  end
 



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
     move_down 50
     indent 20 do
        text "Payment is due immediate.",  size: 10
        text "If you have any questions concerning this invoice, contact us.", size: 10
        text "Phone: 91 80 41123752", size: 10
        text " Email: <u>support@vatonwheels.com</u>", size: 10, :inline_format => true
      end
   
     repeat :all do
        bounding_box [bounds.left, bounds.bottom + 18], width: bounds.width do
           text "This is a computer generated invoice and requires no signature", size: 10, align: :center
        end
     end
  end
     

end
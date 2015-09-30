class BillForReferralPdf < Prawn::Document
  require 'prawn/table'
  include ActionView::Helpers::NumberHelper
  
  
  def initialize(referral, start_date, end_date)
    super()
     #font "Times-Roman"
    #font "Helvetica"
    @referral = referral
    @start_date = start_date
    @end_date = end_date    
    stroke_bounds
    title
    referal
    iprimitus
    ca_accounts
    ca_table
    total_bills
  end

  
  def title
   # font "Times-Roman"
    font "Helvetica"
    draw_text "INVOICE", :at => [220, 690], size: 14
    bounding_box([350, 680], width: 250) do
      text "Invoice Date  : #{Date.today}", size: 10, :inline_format => true
    end
  end
  
  def referal
    bounding_box([320,590], width: 300) do
      text "Bill To,", size: 9
      text "#{@referral.name}", size: 10, :style => :bold, :leading => 2
      text "#{@referral.address_line_1}", size: 9, :leading => 2
      text "#{@referral.address_line_2}", size:9, :leading => 2
      text "#{@referral.state}", size: 9, :leading => 2
      text "Mobile Number : #{@referral.mobile_number}", size: 9
    end    
  end
  
  def iprimitus
    bounding_box([20, 690], width: 350) do
      image open("app/assets/images/iprimitus.jpg"), height: 90, width: 110
      move_down 10
      text "iPrimitus Consultancy Services", size:10, :style => :bold, :leading => 2
      text "43/39, Level 1,",  size: 9, :leading => 2
      text " 2nd cross, Promenade Road" , size: 9, :leading => 2
      text "Bangalore - 560005, India", size: 9, :leading => 2
      text "Mobile number :  9632502351", size: 9
    end
  end
  
  def ca_accounts
     move_down 10
     stroke_horizontal_rule
   
     clients = Client.where('referral_id = ? AND created_at >= ? AND created_at <= ?', @referral.id, @start_date, @end_date)
     clients_count = clients.count
     draw_text "Referral Type                                                                                                  :  #{@referral.referral_type.referral_type}", :at => [15, 450], :style => :bold, size: 10
     draw_text "No. Of Chartered Accountants referred from #{@start_date.strftime("%d-%m-%Y")} till #{@end_date.strftime("%d-%m-%Y")}  :  #{clients_count}", :at => [15, 430], :style => :bold, size: 10
   
  end
  
  def ca_table
    clients = Client.where(:referral_id => @referral.id).order('created_at DESC')
      data = [["Sl.No", "Name of CA" ,"Referred Month", "No Of bills", "Amount"]]
      clients.each_with_index do |client, index|
         index = index + 1
         bills = Bill.where('client_id = ? AND created_at >= ? AND created_at <= ?', client.authuser.id, @start_date, @end_date)
        value = [index, client.authuser.name, client.authuser.created_at.strftime("%B"), bills.count, (bills.count * @referral.referral_type.pricing.to_f).round(2)]
         data += [value]
      end

      bounding_box([10, 410], width: 520) do
        table(data) do
          self.header = true
          self.column(0).width = 50
          self.column(1).width = 200
          self.column(2).width = 100
          self.column(3).width = 70
          self.column(4).width = 100
          self.column(4).style :align => :right
          self.columns(0..3).align = :center
          row(0).background_color = '778899'
          row(0).style = :bold
          self.columns(0..4).size = 11
          row(0).size = 11
           columns(0..4).size = 9
        end
      end
  end

  def total_bills
      clients = Client.where(:referral_id => @referral.id)
      client_ids = clients.select(:authuser_id).map(&:authuser_id)
      bills = Bill.where('created_at >= ? AND created_at <= ?', @start_date, @end_date)
      client_bills = bills.where("client_id IN (?)", client_ids)
      bills_count = client_bills.count
    move_down 10
    data =  [["Total Bills", "#{number_with_delimiter(bills_count, delimiter: ',')}"]]
    indent 280 do
        table(data) do
          self.column(0).width = 150
          self.column(1).width = 100
          column(0).font_style = :bold
          column(0).style :align => :center
          column(1).style :align => :right 
          self.columns(0..1).size = 9
        end
    end
    
    data =  [["Total Amount", "#{number_with_delimiter(((bills_count * @referral.referral_type.pricing.to_f).round(2)), delimiter: ',')}"]]
    indent 280 do
      table(data) do
         self.column(0).width = 150
         self.column(1).width = 100
         column(0).font_style = :bold
         column(0).style :align => :center
         column(1).style :align => :right
        self.columns(0..1).size = 9
      end
    end
    move_down 10
    indent 0, 20 do
      text "<u><b>Rupees #{(bills_count * @referral.referral_type.pricing.to_f).round.to_words} only</b></u>", size: 10, align: :right, :inline_format => true       
     
    end
    
  end

end
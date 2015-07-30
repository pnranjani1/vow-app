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
    iprimitus
    referal
    ca_accounts
    ca_table
    total_bills
  end

  
  def title
   # font "Times-Roman"
#    font "Helvetica"
    draw_text "INVOICE", :at => [220, 690], size: 18
    bounding_box([350, 670], width: 250) do
      text "<b>Invoice Date</b>  : #{Date.today}", size: 11, :inline_format => true
    end
  end
  
  def iprimitus
    bounding_box([20, 640], width: 350) do
      image open("app/assets/images/iprimitus.jpg"), height: 90, width: 110
      move_down 10
      text "iPrimitus Consultancy Services", size:12, :style => :bold, :leading => 3
      text "43/39, Level 1,",  size: 10, :leading => 3
      text " 2nd cross, Promenade Road" , size: 10, :leading => 3
      text "Bangalore - 560005, India", size: 10, :leading => 3
      text "Mobile number :  9632502351", size: 10
    end
  end
  
  
  def referal
    bounding_box([320,570], width: 300) do
      text "Bill To,", size: 12
      text "#{@referral.name}", size: 12, :style => :bold, :leading => 3
      text "#{@referral.address_line_1}", size: 10, :leading => 3
      text "#{@referral.address_line_2}", size:10, :leading => 3
      text "#{@referral.state}", size: 10, :leading => 3
      text "Mobile Number : #{@referral.mobile_number}", size: 10
    end
    
  end
  
  def ca_accounts
     move_down 20
     stroke_horizontal_rule
   
     clients = Client.where('referral_id = ? AND created_at >= ? AND created_at <= ?', @referral.id, @start_date, @end_date)
     clients_count = clients.count
     draw_text "Referral Type                                                                                                  :  #{@referral.referral_type.referral_type}", :at => [15, 430], :style => :bold, size: 11
     draw_text "No. Of Chartered Accountants referred from #{@start_date.strftime("%d-%m-%Y")} till #{@end_date.strftime("%d-%m-%Y")}  :  #{clients_count}", :at => [15, 410], :style => :bold, size: 11
   
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

      bounding_box([10, 380], width: 520) do
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
        end
      end
  end

  def total_bills
      clients = Client.where(:referral_id => @referral.id)
      client_ids = clients.select(:authuser_id).map(&:authuser_id)
      bills = Bill.where('created_at >= ? AND created_at <= ?', @start_date, @end_date)
      client_bills = bills.where("client_id IN (?)", client_ids)
      bills_count = client_bills.count
    move_down 20
    data =  [["Total Bills", "#{number_with_delimiter(bills_count, delimiter: ',')}"]]
    indent 280 do
        table(data) do
          self.column(0).width = 150
          self.column(1).width = 100
          column(0).font_style = :bold
          column(0).style :align => :center
          column(1).style :align => :right 
          self.columns(0..1).size = 11
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
        self.columns(0..1).size = 11
      end
    end
  end
    
end
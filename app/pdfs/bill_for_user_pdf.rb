class BillForUserPdf < Prawn::Document
  require 'prawn/table'
  include ActionView::Helpers::NumberHelper
  
  
  def initialize(user, start_date, end_date)
    super()
     #font "Times-Roman"
    #font "Helvetica"
    @user = user
    @start_date = start_date
    @end_date = end_date    
    stroke_bounds
    title
    client
    user_info
    user_table
    total
  end

  
  def title
   # font "Times-Roman"
#    font "Helvetica"
    draw_text "INVOICE", :at => [220, 690], size: 15
    bounding_box([350, 670], width: 250) do
      text "Invoice Date  : #{Date.today}", size: 10, :inline_format => true
    end
  end
  
  def client
    client_id = @user.users.first.client_id
    client = Authuser.where(:id => client_id).first
    client_logo = client.image_url
    bounding_box([20, 640], width: 350) do
     if client.image.present?
       image open("#{client_logo}"), height: 90, width: 110
     else 
       text "#{client.clients.first.company}"
     end
     
      move_down 10
      text "#{client.name}", size:10, :style => :bold, :leading => 2
      text "#{client.address.address_line_1}",  size: 9, :leading => 2
      text "#{client.address.address_line_2}" , size: 9, :leading => 2
      text "#{client.address.state}", size: 9, :leading => 2
      text "Mobile number :  #{client.membership.phone_number}", size: 9
    end
  end
  
  
  def user_info
   
    draw_text "Bill To,", size: 10, :at => [320, 630]
      if @user.image.present?
        image open(@user.image_url), height: 70, width: 110, crop: "fit", :at => [320,620]
      else      
        draw_text "#{@user.users.first.company}", size: 12, :at => [320, 590]
      end
    bounding_box([320,540], width: 300) do
      text "#{@user.name}", size: 10, :style => :bold, :leading => 2
      text "#{@user.address.address_line_1}", size: 9, :leading => 2
      text "#{@user.address.address_line_2}", size:9, :leading => 2
      text "#{@user.address.state}", size: 9, :leading => 2
      text "Mobile Number : #{@user.membership.phone_number}", size: 10
    end    
    move_down 10
    stroke_horizontal_rule
  end
  
  def user_table
    draw_text "Bills Generation from #{@start_date} to #{@end_date}", size: 9, style: :bold, :at => [30, 440 ]
    data = [["Total No Of Bills" ,"No of Esugam Generated", "No Of Cash Based bills"]]   
    bills = Bill.where('primary_user_id = ? AND created_at >= ? AND created_at <= ?', @user.id, @start_date, @end_date)
    esugam_count = Bill.where('primary_user_id = ? AND created_at >= ? AND created_at <= ? AND ESUGAM IS NOT NULL', @user.id, @start_date, @end_date).count
    cash_based_applications_count =  Bill.where('primary_user_id = ? AND created_at >= ? AND created_at <= ? AND ESUGAM IS NULL', @user.id, @start_date, @end_date).count
    value = [bills.count, esugam_count, cash_based_applications_count]
    data += [value]
    
    bounding_box([30, 420], width: 450) do
     table(data) do
        self.header = true
        self.column(0).width = 150
        self.column(1).width = 150
        self.column(2).width = 150
       columns(0..2).size = 9
        self.columns(0..2).align = :center
        row(0).background_color = '778899'
        row(0).style = :bold
        self.columns(0..2).size = 11
        row(0).size = 9
     end
    end
  end
  
  def total
    bills_count = Bill.where('primary_user_id =? AND created_at >= ? AND created_at <= ?', @user.id, @start_date, @end_date).count
    data = [["<b>Total Bills</b>", "#{bills_count}"]]
     indent 250 do
       table(data, :cell_style => {size: 9, :inline_format => true}) do
          self.column(0).width = 150
          self.column(1).width = 80
          columns(0..1).size = 9
        end
     end
    move_down 10
    indent 0, 50 do
      text "<u><b>#{number_to_currency_in_words(bills_count * 1, currency: :rupee).titleize} only</b></u>", size: 10, align: :right, :inline_format => true   
    end
  end
   
  
end


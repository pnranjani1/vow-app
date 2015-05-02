class ReferralBillPdf < Prawn::Document
  require 'prawn/table'
  
  def initialize(user, start_date, end_date)
    @user = user
    @start_date = start_date
    @end_date = end_date
    
    super()
    stroke_bounds
    title
    logo
    ca_list
  end
  
  def title
    draw_text "CLIENT ACQUISITION REPORT", at: [180, 650], size: 14
  end
  
  def logo
    file = "app/assets/images/iprimitus.jpg"
    image file, at: [10,690], width: 100, height: 90
    draw_text "Date: #{Date.today.strftime("%d %B, %Y")}", at: [390, 600], size: 12
  end
  

  def ca_list
    
    move_down 200
  
    clients = Client.where('created_by = ? AND created_at >= ? AND created_at <= ?', @user.id, @start_date, @end_date)
    clients.count
    indent 20 do
      text "<b>No of Chartered Accountants acquired between #{@start_date.strftime("%d-%b-%Y")} and #{@end_date.strftime("%d-%b-%Y")} :</b>   #{clients.count}", size: 12, inline_format: true
      end
data = [["Sl.No", "Client Name", "No Of Users", "No Of Bills", "Source"]]
      clients.each_with_index do |client, index|
        index = index + 1
        users = User.where(:client_id => client.authuser.id)
        bills = Bill.where(:client_id => client.authuser.id)
        if client.referral.blank?
          referral = "iPrimitus"
        else
          referral = client.referral.name
        end
          #value = [index, client.authuser.name, users.count, bills.count, "iPrimitus"]
        value = [index, client.authuser.name,users.count, bills.count, referral]       
        data += [value]
        end
     
      bounding_box([20, 480], width: 510) do
        table(data) do
          self.header = true
          self.column(0).width = 50
          self.column(1).width = 200
          self.column(2).width = 55
          self.column(3).width = 55
          self.column(4).width = 150
          self.columns(0..4).align = :center
          row(0).background_color = '778899'
          row(0).style = :bold
          row(0).size = 12
        end
     end
  end

  
end
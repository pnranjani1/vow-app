class AdminBillPdf < Prawn::Document
  require 'prawn/table'
 
  
   
  def initialize(user)
    super()
    @user = user
    stroke_bounds
    bill_title
    bill_iprimitus
    logo
    bill_user
    bill_table
    client_users
    total_cost
    authority
  end
     
  def bill_title
    draw_text "INVOICE", :at => [225,690],size: 22
    draw_text "Bill for : #{Date.today.strftime("%B %Y")}" ,:at => [350,670],size:12
  end

  def bill_iprimitus
    draw_text "Company", at: [10,630], size: 14, :style => :bold
    bounding_box([10,620], width: 300) do
      text "iPrimitus Consultancy Services", size: 12
      text "Bangalore", size:12
    end
  end


  def logo
    filename = "app/assets/images/iprimitus.jpg"
    image filename, at: [10,710], width: 150, height: 60
  end

  def  bill_user
     draw_text "Chartered Accountant", at: [350,630], size: 14, :style => :bold
     bounding_box([350,620],:width =>300) do
       if @user.clients.first.company.present?
     text "#{@user.clients.first.company}", size: 12
       end
     text "#{@user.address.address_line_1}", size: 12
     text "#{@user.address.address_line_2}", size: 12
     text "#{@user.address.city}", size: 12
     end
    move_down 10
    stroke_horizontal_rule
  end
  
    
  
       def bill_table           
     draw_text "Bill Details of Each User", at: [20,530], size: 12
     bounding_box([20,510], :width => 550) do
     table client_users do
     row(0).font_style = :bold
     row(0).background_color = '778899'  
     columns(0..3).align = :center
      self.header = true
      self.width = 500
      self.column(0).width = 150
      self.column(1).width = 125
      self.column(2).width = 125
      self.column(3).width = 100
       end
  end
     end
  

 def client_users
   client_user = User.where(:client_id => @user.id)
   [["User Name", "Cash Applications", "E-Sugam generated", "Amount"]] +
   client_user.map do |user|
     cash_based_applications = user.authuser.bills.where('created_at >= ? AND created_at <= ? AND ESUGAM IS NULL', Date.today.beginning_of_month, Date.today.end_of_month).count
     esugam_generated = user.authuser.bills.where('created_at >= ? AND created_at <= ? AND ESUGAM IS NOT NULL', Date.today.beginning_of_month, Date.today.end_of_month).count
     total_bills = cash_based_applications + esugam_generated
     amount  = total_bills* 1
     [user.authuser.name, cash_based_applications, esugam_generated, amount]
   end
    
  end 



  def total_cost
    total_bills = Bill.where('created_at >=? AND created_at <= ? AND client_id =?', Date.today.beginning_of_month, Date.today.end_of_month, @user.id ).count
    data = [["Total Bills", total_bills]]
    table(data, :cell_style => {:font_style => :bold}, :column_widths => [125,100],:position => 295)
    data = [["Bill Amount", (total_bills*1) ]]
    table(data, :cell_style => {:font_style => :bold}, :column_widths => [125,100], :position => 295)
  end
     end
    
  def authority
    move_down 150
    indent 350 do
      text "iPrimitus Consultancy Services", :style => :bold
      move_down 30
      text "Authorized Signatory", :style => :bold
   
  end
  
  
 repeat :all do
      #Create a bounding box and move it up 18 units from the bottom boundry of the page
      bounding_box [bounds.left, bounds.bottom + 18], width: bounds.width do
        text "We Thank You for Your Business", size: 10, align: :center
      end
    end


  end

  

 
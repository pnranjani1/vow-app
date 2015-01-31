class DashboardsController < ApplicationController
 # layout 'menu' , :only => [:user_dashboard]
#  layout 'client', :only => [:client_dashboard]
  
  layout_by_action  user_dashboard: "menu"
  
   filter_access_to :all
 before_filter :authenticate_authuser!
  
  
  def new
  end
  
  def admin_dashboard
    #@clients = Client.where(:authuser_id => current_authuser.id)
   
    @current_authuser_clients = Client.where(:created_by => current_authuser.id)
    @count = @current_authuser_clients.count
   
    @esugam_count = Bill.where("esugam IS NOT NULL").count
    @number_of_cash_applications = Bill.where("esugam IS NULL").count
   end
  
  
  def client_dashboard   
    @users = User.where(:client_id => current_authuser.id)
    @bills = Bill.all
    #@users_count = current_authuser.users.count
    @users_count = @users.count
    @bills_esugam = Bill.where('client_id = ? AND ESUGAM IS NOT NULL', current_authuser.id)
    @cash_based_applications = Bill.where('client_id = ? AND ESUGAM IS NULL', current_authuser.id)
    # to Calcualte total bills under the client
   # users =  User.where(:client_id => current_authuser.id)
    #users.each do |user|
     # user_bills = user.authuser.bills
      # @bills_count = user_bills.sum
    #end
    #@bills_count = user_bills.sum
    
   # @invited_users = Authuser.where('invited_by_id = ? AND name =?', current_authuser.id , ' ')
  end
  
  
  def user_dashboard
  end
  
  def user_request
  end
  
  
    
end

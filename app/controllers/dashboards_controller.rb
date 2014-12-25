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
    
    #  @users = User.where(:client_id => current_authuser.id)
   end
  
  
  def client_dashboard   
    @users = User.where(:client_id => current_authuser.id)
    @bills = Bill.all
   # @invited_users = Authuser.where('invited_by_id = ? AND name =?', current_authuser.id , ' ')
  end
  
  
  def user_dashboard
  end
  
  def user_request
  end
  
  
    
end

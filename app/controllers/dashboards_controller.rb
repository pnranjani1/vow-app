class DashboardsController < ApplicationController
   filter_access_to :all
  #before_filter filter_resource_access
  before_filter :authenticate_authuser!
  
  
  def admin_dashboard
    @clients = Client.where(:authuser_id => current_authuser.id)
    @current_authuser_clients = Client.where(:created_by => current_authuser.id)
    @count = @current_authuser_clients.count
   end
  
  
  def client_dashboard
  end
  
  
  def user_dashboard
  end
  
  
    
end

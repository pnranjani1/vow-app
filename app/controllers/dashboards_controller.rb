class DashboardsController < ApplicationController
 # layout 'menu' , :only => [:user_dashboard]
#  layout 'client', :only => [:client_dashboard]
  
  layout_by_action  [:user_dashboard, :secondary_user_dashboard] =>  "menu"
  
   filter_access_to :all
 before_filter :authenticate_authuser!
  
  
  def new
  end
  
  def admin_dashboard
    #@clients = Client.where(:authuser_id => current_authuser.id)
   
    @current_authuser_clients = Client.where(:created_by => current_authuser.id).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
    @count = @current_authuser_clients.count
   
    @esugam_count = Bill.where("esugam IS NOT NULL").count
    @number_of_cash_applications = Bill.where("esugam IS NULL").count
   end
  
  
  def client_dashboard   
    date = Date.today.strftime("%Y%m%d")
    @users = User.where(:client_id => current_authuser.id).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
    @bills = Bill.all
    #@users_count = current_authuser.users.count
    @users_count = @users.count
    @users_current_month = @users.where('created_at >= ? AND created_at <= ?', date.to_date.beginning_of_month, date.to_date.end_of_month)
    @bills_esugam = Bill.where('client_id = ? AND ESUGAM IS NOT NULL AND created_at >= ? AND created_at <= ?', current_authuser.id, date.to_date.beginning_of_month, date.to_date.end_of_month)
    @cash_based_applications = Bill.where('client_id = ? AND ESUGAM IS NULL AND created_at >= ? AND created_at <= ?', current_authuser.id, date.to_date.beginning_of_month, date.to_date.end_of_month)
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
    date = Date.today.strftime("%Y%m%d")
    #primary_user_esugam = Bill.where('authuser_id =? AND ESUGAM IS NOT NULL AND created_at >= ? AND created_at <= ?', current_authuser.id, date.to_date.beginning_of_month, date.to_date.end_of_month)
    #secondary_user_esugam = Bill.where('primary_user_id =? AND ESUGAM IS NOT NULL AND created_at >= ? AND created_at <= ?', current_authuser.id, date.to_date.beginning_of_month, date.to_date.end_of_month)
    #@bills_esugam = primary_user_esugam & secondary_user_esugam
    @bills_esugam = Bill.where('primary_user_id =? AND ESUGAM IS NOT NULL AND created_at >= ? AND created_at <= ?', current_authuser.id, date.to_date.beginning_of_month, date.to_date.end_of_month)
    
     #primary_user_cash = Bill.where('authuser_id =? AND ESUGAM IS NULL AND created_at >= ? AND created_at <= ?', current_authuser.id, date.to_date.beginning_of_month, date.to_date.end_of_month)
    #secondary_user_cash = Bill.where('primary_user_id =? AND ESUGAM IS NULL AND created_at >= ? AND created_at <= ?', current_authuser.id, date.to_date.beginning_of_month, date.to_date.end_of_month)
    #@cash_based_applications = primary_user_cash & secondary_user_cash
    @cash_based_applications = Bill.where('primary_user_id =? AND ESUGAM IS NULL AND created_at >= ? AND created_at <= ?', current_authuser.id, date.to_date.beginning_of_month, date.to_date.end_of_month)
    #list of secondary_users
    @secondary_users = Authuser.where(:invited_by_id => current_authuser.id) 
  end
  
  def user_request
  end
  
  def secondary_user_dashboard
   # render :layout => 'menu1'
     date = Date.today.strftime("%Y%m%d")
    @bills_esugam = Bill.where('authuser_id = ? AND ESUGAM IS NOT NULL AND created_at >= ? AND created_at <= ?', current_authuser.id, date.to_date.beginning_of_month, date.to_date.end_of_month)
    @cash_based_applications = Bill.where('authuser_id = ? AND ESUGAM IS NULL AND created_at >= ? AND created_at <= ?', current_authuser.id, date.to_date.beginning_of_month, date.to_date.end_of_month) 
  end
    
end

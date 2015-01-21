class AuthusersController < ApplicationController
 # layout_by_action [:change_role, :change_role_update] => "menu1"
  before_filter :authenticate_authuser!
  layout_by_action [:client_new] => "menu"
  #layout "menu1", :only => [ :change_role ]
  
   filter_access_to :all
  
 
 
    def index
   # if params[:approved] == "false"
    #  @users = Authuser.find_all_by_approved(false)
    #else
      @users = Authuser.all
  #  end
  end
 
  
  def new
    @user = Authuser.new
  end
  
 
  def show
  @user = Authuser.find(params[:id])
  @auth_user_category = AuthUserCategory.new
  end
  
  def create
    @user = Authuser.new(set_params)
    if @user.save
      redirect_to authusers_path
    else
      render action: 'new'
    end
  end
  
  
   def edit
    @user = Authuser.find(params[:id])
  end
  
  
  def update
    @user = current_authuser
    if @user.update_attributes(set_params)
      flash[:notice]=  "Password updated successfully"
      if current_authuser.main_roles.first.role_name == 'client'
redirect_to dashboards_client_dashboard_path
      elsif current_authuser.main_roles.first.role_name == 'user'
       redirect_to dashboards_user_dashboard_path
   else
     render action: 'force_password_change'
    end
  end
  end
  
  
   def destroy
    @user = Authuser.find(params[:id])
  @user.destroy
  end
  
  #For client creation
  def admin_new
    @client = Authuser.new
    @client.address = Address.new
    @client.membership = Membership.new
    @client.bankdetail = Bankdetail.new
   # @client.permissions.build
    @client.clients.build   
    @client.users.build
    end
  
  
  def admin_create
    @client = Authuser.new(set_params) 
    if @client.save 
     redirect_to dashboards_admin_dashboard_path
    else
      render action: 'new'
    end
  end
  #keep these for reference
  #if Authuser.joins(:permissions).where(:m_role_id => 1)
     #
 #    if Authuser.joins(:permissions).where(:m_role_id => 5)
   # Client.created_by = current_authuser.id
   # params[:client][:created_by] = current_authuser.id
  
  
  def admin_edit
    @client = current_authuser
  end
  
    
  def admin_update
    @client = current_authuser
    if @client.save
    redirect_to dashboards_client_dashboard_path
    else
      render action: 'admin_edit'
    end
  end
  
  
  def activate_user
    user = Authuser.find(params[:id])
    user.approved = true
    invited_by_id =  user.invited_by_id
    role_invited_by = Permission.where(:authuser_id => invited_by_id)
    role_id = role_invited_by.first.main_role_id
     if user.save
      if role_id == 2
      redirect_to dashboards_client_dashboard_path
      elsif role_id == 1
        redirect_to dashboards_admin_dashboard_path    
       end
  end
  end
    
  
  def de_activate_user
    user = Authuser.find(params[:id])
    user.approved = false
     invited_by_id =  user.invited_by_id
    role_invited_by = Permission.where(:authuser_id => invited_by_id)
    role_id = role_invited_by.first.main_role_id
     if user.save
      if role_id == 2
      redirect_to dashboards_client_dashboard_path
      elsif role_id == 1
        redirect_to dashboards_admin_dashboard_path    
      end
      end
  end
  
  
    
  def change_role
    @user = current_authuser
    @user_roles = current_authuser.main_roles
  end
  
  
  def change_role_update
    @user = current_authuser
#     if @user.current_role == params[:role]
#       flash[:error] = 'This role is already assigned to this user'
#       redirect_to :back
#     else
    #dashboards_admin_dashboard
    #params[:roles] = @user.current_role 
    #@user.current_role = params[:roles]
       redirect_to public_send("dashboards_#{params[:roles]}_dashboard_url") 
    #     end
  end
  

def force_password_change
  @user = current_authuser
end


  
  #for User Creation
  
  def client_new
    @user = current_authuser
    #@user = Authuser.new
   # @user.membership = Membership.new
   # @user.bankdetail = Bankdetail.new
   # @user.address = Address.new
   # @user.permissions.build
   # @user.users.build
  end
  
  def client_create
    @user = Authuser.new(set_params)
    if @user.save
      redirect_to dashboards_user_dashboard_path
  else
      render action: 'client_new'
  end
end
  

def client_edit
  @user = Authuser.find(params[:id])
end


  def client_update
    @user = Authuser.find(params[:id])
      if @user.update_attributes(set_params)
        redirect_to dashboards_user_dashboard_path
        else
        render action: 'edit'
        end
      end
     
  
  private
  def set_params
    params[:authuser].permit(:name, :email, :password, :password_confirmation, :approved, :invited_by_id, :invited_by_type,
     {:membership_attributes => [:id, :phone_number, :membership_start_date, :membership_end_date, :membership_status, :membership_duration]},
       {:address_attributes => [:id, :address_line_1, :address_line_2, :address_line_3, :city, :country]},
      {:bankdetail_attributes => [:id, :bank_account_number, :ifsc_code]},
      {:clients_attributes => [:id, :unique_reference_key, :remarks, :char, :digits, :created_by, :company]}, 
     {:main_role_ids => []},
      {:users_attributes => [:id, :tin_number, :esugam_username, :esugam_password, :client_id]},
      {:permissions_attributes => [:main_role_id]}
     )
  end
  
      
end

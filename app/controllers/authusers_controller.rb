class AuthusersController < ApplicationController
  before_filter :authenticate_authuser!
   filter_access_to :all
  
  
  def index
  end
  
  def new
    @user = Authuser.new
  end
  
 
  def show
  @user = Authuser.find(params[:id])
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
    @user = Authuser.find(params[:id])
    if @user.update_attributes(set_params)
      redirect_to authusers_path
    else
      render action: 'edit'
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
    @client.clients.build
    @user = Authuser.new
    @user.address = Address.new
    @user.membership = Membership.new
    @user.bankdetail = Bankdetail.new
    @user.users.build
    end
  
  
  def admin_create
    @client = Authuser.new(set_params) 
    if @client.save and @user.save
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
  
    
  def admin_update
    @client = Authuser.find(params[:id])
    if @client.update_attributes(set_params)
      redirect_to authuser_path(@client.id)
    else
      render action: 'edit'
    end
  end
  
  
  #for User Creation
  
  def client_new
    @user = Authuser.new
    @user.membership = Membership.new
    @user.bankdetail = Bankdetail.new
    @user.address = Address.new
    @user.users.build
  end
  
  def client_create
    @user = Authuser.new(set_params)
    if @user.save
      redirect_to dashboards_user_dashboard_path
  else
    render action: 'new'
  end
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
    params[:authuser].permit(:name, :email, :password,
     {:membership_attributes => [:id, :phone_number, :membership_start_date, :membership_end_date, :membership_status, :membership_duration]},
       {:address_attributes => [:id, :address_line_1, :address_line_2, :address_line_3, :city, :country]},
      {:bankdetail_attributes => [:id, :bank_account_number, :ifsc_code]},
      {:clients_attributes => [:id, :unique_reference_key, :remarks, :char, :digits, :created_by]}, 
     {:main_role_ids => []},
      {:users_attributes => [:id, :tin_number, :esugam_username, :esugam_password, :client_id]}
     )
  end
  
      
end

class UsersController < ApplicationController
 # before_filter :authenticate_authuser!
  before_filter filter_resource_access
  
   
  
  def index
  end
  
  def new
    @user = Authuser.find(current_authuser.id)
    @user.membership = Membership.new
    @user.bankdetail = Bankdetail.new
   @user.address = Address.new
   @user.users.build
  end
  
  def create
    @user = Authuser.find(current_authuser.id)
    if @user.save(set_params)
      redirect_to user_dashboard_path(current_authuser.id)
    else
      render adtion: 'new'
    end
  end
  
  
  def show
    @user = Authuser.find(params[:id])
  end
  
  def edit
    @user = Authuser.find(params[:id])
  end
  
  def update
    @user = Authuser.find(current_authuser.id)
    if @user.update_attributes(set_params)
      redirect_to dashboards_user_dashboard_path
    else render action: 'edit'
    end
  end
  
  def destroy
    @user = Authuser.find(params[:id])
    @user.destroy
  end
  
  private
  def set_params
    params[:authuser].permit(:name, :email, :password, :password_confirmation,
      {:membership_attributes => [:phone_number, :membership_start_date, :membership_end_date, :membership_status, :membership_duration]},
      {:users_atributes => [:tin_number, :client_id, :authuser_id, :esugam_username, :esugam_password]},
      {:address_attributes => [:address_line_1, :address_line_2, :address_line_3, :city, :country, :authuser_id]},
      {:bankdetail_attributes => [:bank_account_number, :ifsc_code]}
       )
      end
  
    
end


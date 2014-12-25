class AdminsController < ApplicationController
 
  
  def index
    @admins = Admin.all
  end
  
  
  def new
    @admin = Authuser.new
    @admin.membership = Membership.new
    @admin.address = Address.new
    @admin.permissions.build
    @admin.admins.build
  end
  
  
  def create
    @admin = Authuser.new(set_params)
   # @admin.authuser_id = current_authuser.id
    if @admin.save
      redirect_to dashboards_admin_dashboard_path
    else
      render action: 'new'
    end
  end
  
  def show
    @admin = Authuser.find(params[:id])
  end
  
  def edit
    @admin = Authuser.find(params[:id])
  end
  
  
  def update
    @admin = Authuser.find(params[:id])
    if @admin.update_attributes(set_params)
      redirect_to dasboards_admin_dashboard_path
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @admin = Authuser.find(params[:id])
    @admin.destroy
    redirect_to root_url
  end
  
  private
  def set_params
    params[:authuser].permit(:name, :email, :password, :approved,
      {:membership_attributes => [:phone_number, :membership_start_date, :membership_end_date]},
      {:address_attributes => [:address_line_1, :address_line_2, :address_line_3, :city, :country]},
      {:permissions_attributes => [:main_role_id, :authuser_id]}
      )
  end
  
  
end

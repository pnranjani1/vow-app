class MembershipsController < ApplicationController
   before_filter :authenticate_authuser!
  before_filter filter_resource_access
  
  
  def index
  end
  
  def new
    @membership = Membership.new
  end
  
  def create
    @membership = Membership.new(set_params)
    if @membership.save
      redirect_to membership_path(@membership.id)
    else
      render action: 'new'
    end    
  end
  
  def show
    @membership = Membership.find(params[:id])
   end
  
  def edit
    @membership = Membership.find(params[:id])
    @current_authuser_clients = Client.where(:created_by => current_authuser.id)
  end
  
  
  def update
    @membership = Membership.find(params[:id])
    if @membership.update_attributes(set_params)
      invited_by_id =  @membership.authuser.invited_by_id
      role_invited_by = Permission.where(:authuser_id => invited_by_id)
      role_id = role_invited_by.first.main_role_id
      if @membership.save
      if role_id == 2
      redirect_to dashboards_client_dashboard_path
      elsif role_id == 1
        redirect_to dashboards_admin_dashboard_path
    else render action: 'edit'
    end
  end
  end
  end
  
  
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
  end
  
  
  private
  
  def set_params
    params[:membership].permit(:authuser_id, :phone_number, :membership_start_date, :membership_end_date, :membership_status, :membership_duration)
  end

end

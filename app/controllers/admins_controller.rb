class Admins < ApplicationController
  before_filter filter_resource_access
  #before_filter :authenticate_authuser!
  
  def index
  end
  
  def new
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new(set_params)
    #@admin.user_id = current_user.id
    if @admin.save
      redirect_to dashboards_path
    else
      render action: 'new'
    end
  end
  
  def edit
    @admin = Admin.find(params[:id])
  end
  
  def show
    @admin = Admin.find(params[:id])
  end
  
  def update
    @admin = Admin.find(params[:id])
    #@admin.user_id = current_user.id
    if @admin.update_attributes(set_params)
      redirect_to admin_path(@admin.id)
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
  end
  
  private
  def set_params
    params[:admin].permit(:name, :email, :password)
  end
end

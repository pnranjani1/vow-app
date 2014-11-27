class UsersController < ApplicationController
  
  before_filter :authenticate_authuser!
  
   
  
   def index
  end
  
  def new
    @user = User.new
    @authuser = AuthUser.new
  end
  
  def create
    @user = User.new(set_params)
    if @user.save
      redirect_to user_dashboard_path(@user.id)
    else
      render adtion: 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(set_params)
      redirect_to user_dashboard_path(@user.id)
    else render action: 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end
  
  private
  def set_params
    params[:user].permit(:tin_number, :client_id, :authuser_id, :esugam_username, :esugam_password)
  end
  
    
end


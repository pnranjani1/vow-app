class AddressesController < ApplicationController
  layout 'menu'
   before_filter :authenticate_authuser!
  before_filter filter_resource_access
  
  
  def index
  end
  
  def new
    @address = Address.new
  end
  
  def create
    @address = Address.new(set_params)
    if @address.save
      redirect_to address_pth(current_authuser.id)
    else
      render action: 'new'
    end    
  end
  
  def show
    @address = Address.find(params[:id])
   end
  
  def edit
    @address = Address.find(params[:id])
  end
  
  def update
    @address = Address.find(params[:id])
    if @address.update_attributes(set_params)
      redirect_to address_path(current_authuser.id)
    else render action: 'edit'
    end
  end
  
  
  def destroy
    @address = Address.find(params[:id])
    @address.destroy
  end
  
  
  private
  
  def set_params
    params[:address].permit(:address_line_1, :address_line_2, :address_line_3, :city, :state, :country, :authuser_id)
   end
  

  
end

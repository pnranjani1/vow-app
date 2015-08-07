class UnregisteredCustomersController < ApplicationController
  before_filter :authenticate_authuser!
  
  def index
  end
  
  def new
    @unregistered_customer = UnregisteredCustomer.new
  end
  
  def create
    @unregistered_customer = UnregisteredCustomer.new(set_params)
    if @unregistered_customer.save
      redirect_to unregistered_customers_path
    else
      render action: 'new'
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
  private
  
  def set_params
    params[:unregistered_customer].permit(:customer_name, :phone_number, :address, :city, :state, :authuser_id)
  end
  
end

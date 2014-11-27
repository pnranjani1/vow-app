class CustomersController < ApplicationController
  
  filter_access_to :all
  before_filter :authenticate_authuser!
  before_filter :get_customer, only: [:show, :edit, :update, :destroy]
  
  def index
    @customers = Customer.order('Created_at DESC')
  end
  
  def show
  end
  
  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.new(set_params)
    @customer.authuser_id = current_authuser.id
    if @customer.save
      redirect_to customer_path(@customer)
    else
      render action: 'new'
    end
  end
  
  def edit
  end
  
  def update
    @customer.authuser_id = current_authuser.id
    if @customer.update_attributes(set_params)
      redirect_to customer_path(@customer)
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @customer.destroy
    redirect_to customers_path
  end
  
  def user_customer
    @user = Authuser.find(params[:id])
  end
  
  
  private
  def set_params
    params[:customer].permit(:name, :email, :tin_number, :phone_number, :address, :city, :authuser_id)
  end
  
  def get_customer
    @customer = Customer.find_by_permalink(params[:id])
  end
  
end

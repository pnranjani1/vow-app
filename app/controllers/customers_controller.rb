class CustomersController < ApplicationController
  #layout 'menu', :only => [:user_customer, :new, :create, :edit, :update, :show, :destroy, :customer_import]
    layout_by_action [:user_customer, :new, :create, :edit, :update, :show, :destroy, :customer_import] => "menu"
     
  filter_access_to :all
  before_filter :authenticate_authuser!
  #before_filter :get_customer, only: [:show, :edit, :update, :destroy]
  
  def index
    @customers = Customer.all.order('Created_at DESC')
  end
  
  def show
    @customer = Customer.find(params[:id])
   end
  
  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.new(set_params)
  @customer.authuser_id = current_authuser.id
    if @customer.save
      redirect_to customer_path(@customer.id)
    else
      render action: 'new'
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def update
    @customer = Customer.find(params[:id])
    @customer.authuser_id = current_authuser.id
    if @customer.update_attributes(set_params)
      redirect_to customer_path(@customer.id)
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to customers_path
  end
  
  def user_customer
    @user_customers =  Customer.where(:authuser_id => current_authuser.id)
    
  end
  
  
  def customer_import
    Customer.import(params[:file], current_authuser.id)
    redirect_to customers_path, notice: "Customers Imported"
  end
    
  
  def customer_download
    @customer = Customer
    respond_to do |format|
      format.html
      format.xls
    end
  end
   
  
  private
  def set_params
    params[:customer].permit(:name, :email, :tin_number, :phone_number, :address, :city, :authuser_id)
  end
  
  #def get_customer
   # @customer = Customer.find_by_permalink(params[:id])
 # end
  
end

class CustomersController < ApplicationController
  #layout 'menu', :only => [:user_customer, :new, :create, :edit, :update, :show, :destroy, :customer_import]
    layout_by_action [:user_customer, :new, :create, :edit, :update, :show, :destroy, :customer_import, :customer_import_report] => "menu"
     
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
      redirect_to customers_user_customer_path
      flash[:notice] = "Customer Created Successfully"
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
      redirect_to customers_user_customer_path
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to customers_user_customer_path
  end
  
  def user_customer
    @user_customers =  Customer.where(:authuser_id => current_authuser.id).paginate(:page => params[:page], :per_page => 5)
    
  end
  
  
  def customer_import
     if params[:file].nil?
       redirect_to customers_customer_import_report_path, alert: 'Please Select a file to import'
    else
    begin
      Customer.import(params[:file], current_authuser.id)
      redirect_to customers_user_customer_path, notice: "Customers Successfully Imported"
    rescue       
    # @error = "#{e.message}"
      # flash[:alert] = "#{@customers.errors.full_messages}"
       #flash[:alert] = "Check the data in excel"
      redirect_to customers_customer_import_report_path,  alert: "Name, Email and Tin Number can't be Blank, TIN Number should be 11 numbers"
    end
     end
   end
  
  def customer_import_report
    @customer = Customer.new
   # if @customer.valid?
    #  @customer.save
    #else
      
  end
    
  
  def customer_download
    @customer = Customer
    respond_to do |format|
      format.html
      format.xls
    end
  end
   
  
  def newcustomer_in_bill
    @customer = Customer.new
    @customer.authuser_id = current_authuser.id
    if @customer.update_attributes(set_params)
      redirect_to new_bill_path
     else
      render action: 'new'
     end
  end
  
  private
  def set_params
    params[:customer].permit(:name, :email, :tin_number, :phone_number, :address, :city, :authuser_id, :state, :pin_code)
  end
  
  #def get_customer
   # @customer = Customer.find_by_permalink(params[:id])
 # end
  
end

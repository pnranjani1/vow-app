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
    if current_authuser.main_roles.first.role_name == "secondary_user"
      invited_by_user_id = current_authuser.invited_by_id
      invited_user = Authuser.find(invited_by_user_id)
      @customer.authuser_id = current_authuser.id
      @customer.primary_user_id = invited_by_user_id
    else
      @customer.authuser_id = current_authuser.id
      @customer.primary_user_id = current_authuser.id
    end
    if current_authuser.main_roles.first.role_name == "secondary_user"
      @user_customers = Customer.where(:primary_user_id => [current_authuser.id, current_authuser.invited_by.id])
    else 
      @user_customers = Customer.where(:primary_user_id => current_authuser.id)
    end
    customers = @user_customers.pluck(:name)
    if customers.any?{|customer| customer.downcase.gsub(/\s/,"")["#{params[:customer][:name].downcase.gsub(/\s/,"")}"]}
      redirect_to customers_user_customer_path
    flash[:alert] = "#{params[:customer][:name]} is already added"
    else    
      if @customer.save
        redirect_to customers_user_customer_path
        flash[:notice] = "Customer Created Successfully"
      else
        render action: 'new'
      end
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def update
    @customer = Customer.find(params[:id])
    if current_authuser.main_roles.first.role_name == "secondary_user"
      invited_by_user_id = current_authuser.invited_by_id
      invited_user = Authuser.find(invited_by_user_id)
      @customer.authuser_id = current_authuser.id
      @customer.primary_user_id = invited_by_user_id
    else
      @customer.authuser_id = current_authuser.id
      @customer.primary_user_id = current_authuser.id
    end
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
    if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
        @user_customers =  Customer.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
    else
       @user_customers =  Customer.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
    end  
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
      redirect_to customers_customer_import_report_path,  alert: "Name, Email and Tin Number can not be Blank, TIN Number should be 11 numbers"
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
     if current_authuser.main_roles.first.role_name == "secondary_user"
      invited_by_user_id = current_authuser.invited_by_id
      invited_user = Authuser.find(invited_by_user_id)
      @customer.authuser_id = current_authuser.id
      @customer.primary_user_id = invited_by_user_id
    else
      @customer.authuser_id = current_authuser.id
      @customer.primary_user_id = current_authuser.id
    end
    if current_authuser.main_roles.first.role_name == "secondary_user"
       @user_customers = Customer.where(:primary_user_id => [current_authuser.id, current_authuser.invited_by.id])
    else
      @user_customers = Customer.where(:primary_user_id => current_authuser.id)
    end
    customers = @user_customers.pluck(:name)
    if customers.any?{|customer| customer.downcase.gsub(/\s/,"")["#{params[:customer][:name].downcase.gsub(/\s/,"")}"]}
      #redirect_to customers_user_customer_path
      redirect_to new_bill_path
    flash[:alert] = "#{params[:customer][:name]} is already added"
    else  
      if @customer.update_attributes(set_params)
         redirect_to new_bill_path
      else
         render action: 'new'
      end
    end
  end

  def new_customer_in_edit
    @customer = Customer.new
    @bill = Bill.find(params[:id])
    if current_authuser.main_roles.first.role_name == "secondary_user"
      invited_by_user_id = current_authuser.invited_by_id
      invited_user = Authuser.find(invited_by_user_id)
      @customer.authuser_id = current_authuser.id
      @customer.primary_user_id = invited_by_user_id
    else
      @customer.authuser_id = current_authuser.id
      @customer.primary_user_id = current_authuser.id
    end
    if current_authuser.main_roles.first.role_name == "secondary_user"
       @user_customers = Customer.where(:primary_user_id => [current_authuser.id, current_authuser.invited_by.id])
    else
      @user_customers = Customer.where(:primary_user_id => current_authuser.id)
    end
    customers = @user_customers.pluck(:name)
    if customers.any?{|customer| customer.downcase.gsub(/\s/,"")["#{params[:customer][:name].downcase.gsub(/\s/,"")}"]}
      #redirect_to customers_user_customer_path
      redirect_to new_bill_path
    flash[:alert] = "#{params[:customer][:name]} is already added"
    else  
      if @customer.update_attributes(set_params)
        user_id = @customer.authuser_id
        user = Authuser.where(:id => user_id).first
        
        redirect_to edit_bill_path(@bill.id)
      else
        render action: 'new'
      end
    end
  end

  def download_customer
    if current_authuser.main_roles.first.role_name == "secondary_user"
       @customers = Customer.where(:primary_user_id => [current_authuser.id, current_authuser.invited_by.id])
    else
      @customers = Customer.where(:primary_user_id => current_authuser.id)
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

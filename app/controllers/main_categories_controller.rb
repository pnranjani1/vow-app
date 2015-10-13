class MainCategoriesController < ApplicationController
  
  
 filter_access_to :all
  before_filter :authenticate_authuser!
  #before_filter :get_customer, only: [:show, :edit, :update, :destroy]
  
  def index
    @categories = MainCategory.all.order('commodity_name').paginate(:page => params[:page], :per_page => 5)
  end
  
  def show
    @category = MainCategory.find(params[:id])
   end
  
  def new
    @category = MainCategory.new
  end
  
  def create
    @category = MainCategory.new(set_params)
#    @customer.authuser_id = current_authuser.id
    commodities = MainCategory.all.pluck(:commodity_name)
    if commodities.any?{|commodity| commodity.downcase.gsub(/\s/,"")["#{params[:main_category][:commodity_name].downcase.gsub(/\s/,"")}"]}
      redirect_to main_categories_path
      flash[:alert] = "#{params[:main_category][:commodity_name]} is already added"
    else
       if @category.save
          redirect_to main_categories_path
          flash[:notice] = "Commodity Successfully Created!"
       else
          render action: 'new'
       end
    end
  end
  
  def edit
    @category = MainCategory.find(params[:id])
  end
  
  def update
    @category = MainCategory.find(params[:id])
   # @customer.authuser_id = current_authuser.id
    if @category.update_attributes(set_params)
      redirect_to main_categories_path
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @category = MainCategory.find(params[:id])
    @category.destroy
    redirect_to main_categories_path
  end
  
  def user_customer
    @user = Authuser.find(params[:id])
  end
  
  def category_download
    @category = MainCategory
    respond_to do |format|
      format.html
      format.xls
    end
  end
   
  
  def category_import
    @category = params[:file]
    if @category.nil?
      redirect_to main_categories_category_import_report_path, alert: 'Please Select a file to import'
   
    else
      begin
        MainCategory.import(params[:file])
        redirect_to main_categories_path, notice: "Commodities Successfully Imported."
      rescue
        redirect_to main_categories_category_import_report_path,  alert: "Commodity Name and Commodity Code can not be blank"
    end
  end
 end
  
  
  def category_import_report
    @category = MainCategory.new 
  end

  def download_commodity
    @main_categories = MainCategory.all
  end
  
  private
  def set_params
    params[:main_category].permit(:commodity_name, :commodity_code, :sub_commodity_code)
  end
  
  #def get_customer
   # @customer = Customer.find_by_permalink(params[:id])
 # end
  
end

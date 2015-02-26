class ProductsController < ApplicationController
#  layout 'menu' , :only => [:product_user, :new, :edit, :update, :destroy, :create, :show]
  layout_by_action [:product_user, :new, :edit, :update, :destroy, :create, :show, :product_import_report] => "menu"
  
  filter_access_to :all
  before_filter :authenticate_authuser!
 # before_filter :get_product, only: [:show, :edit, :update, :destroy]
  
  def index
  @products = Product.all
    end
  
   def new
    @product = Product.new
  #  @product.build_price
    @categories = MainCategory.joins(:usercategories).where('usercategories.authuser_id' => current_authuser.id).map(&:commodity_name) 
     @usercategories = Usercategory.where(:authuser_id => current_authuser.id)
     
  end
  
 
   def create
   @product = Product.new(set_params)
   @product.authuser_id = current_authuser.id 
   params[:usercategory_id] = @product.usercategory_id
   if @product.save 
     redirect_to products_product_user_path(current_authuser.id)
     flash[:notice] = "Product Created Successfully"
   else 
   render action: 'new'
    end
    end   
   

   def show
    @product = Product.find(params[:id])
  end
  
   
  def edit
    @product = Product.find(params[:id])
    @categories = MainCategory.joins(:usercategories).where('usercategories.authuser_id' => current_authuser.id).map(&:commodity_name) 
  end
  
   
  def update
    @product = Product.find(params[:id])
   @product.authuser_id = current_authuser.id    
    if @product.update_attributes(set_params)
      redirect_to products_product_user_path
    else
      render action: 'edit'
    end
  end
  
  
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_product_user_path
  end
  
  
  def product_category
    @category = Category.find(params[:id])
    @category_products = @category.products.paginate(:page => params[:page], :per_page => 2)
   end
  
    def product_user
      @user_products = Product.where(:authuser_id => current_authuser.id).paginate(:page => params[:page], :per_page => 5)
    end
  
  def usercategory_product
      @category_product = Usercategory.where(:authuser_id => current_authuser.id)
       respond_to do |format|
      format.html      
      format.xls 
     end
  end
  
  def product_download
    @product = Product
    respond_to do |format|
      format.html
      format.xls
    end
  end
   
  
  def product_import
    @product = params[:file]
    if @product.nil?
      redirect_to products_product_import_report_path, alert: 'Please Select a file to import'
   
    else
      begin
    Product.import(params[:file], current_authuser.id)
   redirect_to products_product_user_path, notice: "Products Successfully Imported."
      rescue
        redirect_to products_product_import_report_path,  alert: "Product Name, Units and Usercategory Id can't be blank"
    end
     
  end
  end
  
  
  def product_import_report
    @product = Product.new 
    end
  
  
  
  def newproduct_in_bill
    @product = Product.new
    @product.authuser_id = current_authuser.id
    if @product.update_attributes(set_params)
      redirect_to new_bill_path
    else
      render action: 'new'
    end
  end
  
 private
    
    def set_params
      params[:product].permit(:product_name, :units, :usercategory_id, :authuser_id, 
        {:price_attributes => [:unit_price]}
        ) 
    end
  
 end
  
 
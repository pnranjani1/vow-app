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
      if current_authuser.main_roles.first.role_name == "secondary_user"
        invited_by_user_id = current_authuser.invited_by_id
        invited_user = Authuser.find(invited_by_user_id)
        @product.authuser_id = current_authuser.id
        @product.primary_user_id = invited_by_user_id
      else
        @product.primary_user_id = current_authuser.id
        @product.authuser_id = current_authuser.id
      end
      params[:usercategory_id] = @product.usercategory_id
     if current_authuser.main_roles.first.role_name == "secondary_user"
      @user_products = Product.where(:primary_user_id => [current_authuser.id, current_authuser.invited_by.id])
     else
       @user_products = Product.where(:primary_user_id => current_authuser.id)
     end
      products = @user_products.pluck(:product_name)
      if products.any?{|product| product.downcase.gsub(/\s/, "")["#{params[:product][:product_name].downcase.gsub(/\s/,"")}"]}
        redirect_to products_product_user_path
        flash[:alert] = "#{params[:product][:product_name]} is already added" 
      else
        if  @product.save 
         redirect_to products_product_user_path(current_authuser.id)
         flash[:notice] = "Product Created Successfully" 
        else
           render action: 'new'
        end
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
     if current_authuser.main_roles.first.role_name == "secondary_user"
        invited_by_user_id = current_authuser.invited_by_id
        invited_user = Authuser.find(invited_by_user_id)
        @product.authuser_id = current_authuser.id
        @product.primary_user_id = invited_by_user_id
      else
       @product.primary_user_id = current_authuser.id
        @product.authuser_id = current_authuser.id
      end
      if current_authuser.main_roles.first.role_name == "secondary_user"
        @user_products = Product.where('primary_user_id = ? AND product_name != ?', [current_authuser.id, current_authuser.invited_by.id], @product.product_name)
      else
        @user_products = Product.where('primary_user_id = ? AND product_name != ? ', current_authuser.id, @product.product_name)
      end
      products = @user_products.pluck(:product_name)
      if products.any?{|product| product.downcase.gsub(/\s/, "")["#{params[:product][:product_name].downcase.gsub(/\s/,"")}"]}
        redirect_to products_product_user_path
        flash[:alert] = "#{params[:product][:product_name]} is already added" 
      else    
       if @product.update_attributes(set_params)
        redirect_to products_product_user_path
       else
         render action: 'edit'
       end
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
      if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
         @user_products = Product.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
      else
        @user_products = Product.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
      end
    end
  
  def usercategory_product
    if current_authuser.main_roles.first.role_name == "secondary_user"
      primary_user_id = current_authuser.invited_by_id
      @category_product = Usercategory.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id)
       respond_to do |format|
        format.html      
        format.xls 
       end
    else
      @category_product = Usercategory.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
       respond_to do |format|
        format.html      
        format.xls 
       end
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
        redirect_to products_product_import_report_path,  alert: "Product Name, Units and Usercategory Id can not be blank"
    end
     
  end
  end
  
  
  def product_import_report
    @product = Product.new 
    end
  
  
  
  def newproduct_in_bill
    @product = Product.new     
    if current_authuser.main_roles.first.role_name == "secondary_user"
        invited_by_user_id = current_authuser.invited_by_id
        invited_user = Authuser.find(invited_by_user_id)
        @product.authuser_id = current_authuser.id
        @product.primary_user_id = invited_by_user_id
      else
        @product.primary_user_id = current_authuser.id
        @product.authuser_id = current_authuser.id
      end
    if current_authuser.main_roles.first.role_name == "secondary_user"
      @user_products = Product.where(:primary_user_id => [current_authuser.id, current_authuser.invited_by.id])
    else
      @user_products = Product.where(:primary_user_id => current_authuser.id)
    end
    products = @user_products.pluck(:product_name)
    if products.any?{|product| product.downcase.gsub(/\s/,"")["#{params[:product][:product_name].downcase.gsub(/\s/,"")}"]}
      redirect_to new_bill_path
    flash[:alert] = "#{params[:product][:product_name]} is already added"
    else
      if @product.update_attributes(set_params)
        redirect_to new_bill_path
      else
        render action: 'new'
      end
    end
  end

  def new_product_in_edit
    @product = Product.new     
    if current_authuser.main_roles.first.role_name == "secondary_user"
        invited_by_user_id = current_authuser.invited_by_id
        invited_user = Authuser.find(invited_by_user_id)
        @product.authuser_id = current_authuser.id
        @product.primary_user_id = invited_by_user_id
      else
        @product.primary_user_id = current_authuser.id
        @product.authuser_id = current_authuser.id
      end
    if current_authuser.main_roles.first.role_name == "secondary_user"
      @user_products = Product.where(:primary_user_id => [current_authuser.id, current_authuser.invited_by.id])
    else
      @user_products = Product.where(:primary_user_id => current_authuser.id)
    end
    products = @user_products.pluck(:product_name)
    if products.any?{|product| product.downcase.gsub(/\s/,"")["#{params[:product][:product_name].downcase.gsub(/\s/,"")}"]}
      redirect_to new_bill_path
    flash[:alert] = "#{params[:product][:product_name]} is already added"
    else
      if @product.update_attributes(set_params)
        redirect_to edit_bill_path
      else
        render action: 'new'
      end
    end
  end

  def download_product
    if current_authuser.main_roles.first.role_name == "secondary_user"
      @products = Product.where(:primary_user_id => [current_authuser.id, current_authuser.invited_by.id])
    else
      @products = Product.where(:primary_user_id => current_authuser.id)
    end
  end
  
 private
    
    def set_params
      params[:product].permit(:id, :product_name, :units, :usercategory_id, :authuser_id, 
        {:price_attributes => [:unit_price]}
        ) 
    end
  
 end
  
 
class MainCategoriesController < ApplicationController
  
  
 filter_access_to :all
  before_filter :authenticate_authuser!
  #before_filter :get_customer, only: [:show, :edit, :update, :destroy]
  
  def index
    @categories = MainCategory.all
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
    if @category.save
      redirect_to main_categories_path
    else
      render action: 'new'
    end
  end
  
  def edit
    @category = MainCategory.find(params[:id])
  end
  
  def update
    @category = MainCategory.find(params[:id])
   # @customer.authuser_id = current_authuser.id
    if @category.update_attributes(set_params)
      redirect_to main_category_path(@category.id)
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
  
  
  private
  def set_params
    params[:main_category].permit(:commodity_name, :commodity_code, :sub_commodity_code)
  end
  
  #def get_customer
   # @customer = Customer.find_by_permalink(params[:id])
 # end
  
end

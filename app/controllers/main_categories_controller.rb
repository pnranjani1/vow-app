class MainCategoriesController < ApplicationController
  before_filter :authenticate_authuser!
  before_filter filter_resource_access
   
  
  def index
    @categories = MainCategory.all
  end
  
  def new
    @category = MainCategory.new
  end
  
  
  def create
    @category = MainCategory.new(set_params)
   if @category.save
    redirect_to main_categories_path
  else
    render action: 'new'
  end
  end
  
  
  def show
    @category = MainCategory.find(params[:id])
  end
  
    
  def edit
  @category = MainCategory.find(params[:id])
end
  

def update
  @category = MainCategory.find(params[:id])
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

  
  private
  
  def set_params
    params[:main_category].permit(:commodity_name, :commodity_code, :sub_commodity_code)
  end
      
end
  
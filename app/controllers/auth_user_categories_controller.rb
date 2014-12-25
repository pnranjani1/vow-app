class AuthUserCategoriesController < ApplicationController
#  layout 'menu', :only => [:index, :new, :create, :edit, :show, :update, :destroy]
  layout_by_action [:index, :new, :create, :edit, :show, :update, :destroy] => "menu"

  
  def index
    @auth_user_category = current_authuser.auth_user_category
    
  end
  
  

  def new
    @auth_user_category = AuthUserCategory.new
   
    #@user = Authuser.find(current_authuser.id)
  end
  
  
  def create
    @auth_user_category = AuthUserCategory.new(params_auth_user_category)
    @auth_user_category.authuser_id = current_authuser.id
     @auth_user_category.usercategories.each do|b|
      b.authuser_id = current_authuser.id
    end
        
    if @auth_user_category.save
      redirect_to auth_user_categories_path
    else
      render action: 'new'
    end
  end
  

  def show
  end
  
  def product_list
  @usercategories = Usercategory.where(:authuser_id => current_authuser.id)
  end
  
  
  def edit
    @auth_user_category = AuthUserCategory.find(params[:id])    
  end
  
  
  def update
    @auth_user_category = AuthUserCategory.find(params[:id]) 
    
     @auth_user_category.usercategories.each do|b|
      b.authuser_id = current_authuser.id
    end
  
    if @auth_user_category.update_attributes(params_auth_user_category)
      
      if @auth_user_category.usercategories.blank?
       @auth_user_category.destroy 
        redirect_to new_auth_user_category_path
        end  
      
      redirect_to auth_user_categories_path
    else
      render action: 'edit'
    end
  end
  
  
  
  private
  
  def params_auth_user_category
    params[:auth_user_category].permit(:authuser_id, {usercategories_attributes: [:id, :main_category_id, :_destroy]})
  end
end

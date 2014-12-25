class UsercategoriesController < ApplicationController
  
  filter_access_to :all
  before_filter :authenticate_authuser!
  
  
  def index
    @usercategories = Usercategory.all
  end
  
  
   def new
     @user = Authuser.find(current_authuser.id)
     @usercategory = Usercategory.new
   end
  
  
  
    def create
    @usercategory = Usercategory.new(set_params)
      @usercategory.authuser_id = current_authuser.id
      if @usercategory.save 
        redirect_to usercategory_path(@usercategory.id)
    else
      render action: 'new'
     end
  end   
  
  
  def show
    @usercategory = Usercategory.find(params[:id])
  end
  
  
  
   def edit
     @usercategory = Usercategory.find(params[:id])
    end
  

  def update
    @usercategory = Usercategory.find(params[:id])
    @usercategory.authuser_id = current_authuser.id
    if @usercategory.update_attributes(set_params)
      redirect_to usercategory_path(@usercategory.id)
    else 
      render action: 'edit'
  end
  end
  
  
 
  def destroy
    @usercategory = Usercategory.find(params[:id])
    @usercategory.destroy
    redirect_to usercategories_path
  end
  
  
  
  
  
  private
    def set_params
      params[:usercategory].permit(:authuser_id, :main_category_id)
    end
  
  
   
end


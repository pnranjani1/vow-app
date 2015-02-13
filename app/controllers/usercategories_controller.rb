class UsercategoriesController < ApplicationController
  filter_access_to :all
  before_filter :authenticate_authuser!
  before_filter :get_available_categories, only: [:new, :create, :edit, :update]
  layout_by_action [:new, :create, :show, :edit, :update, :index] => "menu"
  
  def index
  #  @usercategories = current_authuser.usercategories.paginate(:page => params[:page], :per_page => 3)
    @usercategories = Usercategory.where(:authuser_id => current_authuser.id).paginate(:page => params[:page], :per_page => 1)
  end
  
  def new
    @usercategory = Usercategory.new
    #@user = Authuser.find(current_authuser.id)
  end
  
  def create
    @usercategory = Usercategory.new(set_params)
    @usercategory.authuser_id = current_authuser.id
    
    if @usercategory.save 
      redirect_to usercategories_path(current_authuser.id)
      flash[:notice] = "Commodity Added Successfully"
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
  def get_available_categories
    @available_categories = Usercategory.available_categories(current_authuser)
    
    if @available_categories.blank?
      flash[:alert] = 'Sorry, all the commodities are already added.'
      redirect_to  usercategories_path
    end
  end
  
    def set_params
      params[:usercategory].permit(:authuser_id, :main_category_id)
    end
  
  
   
end


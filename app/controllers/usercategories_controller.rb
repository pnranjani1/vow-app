class UsercategoriesController < ApplicationController
  filter_access_to :all
  
  #before_filter :authenticate_authuser!
  before_filter :get_category, only: [:show, :edit, :update, :destroy]
  
  
  def index
    @categories = Usercategory.all
  #  @categories = Category.paginate(:page => params[:page], :per_page => 2)
  end
  
  
  
  def show
    @cat = @category.m_category_id
    @usercategories = MCategory.find(:id => @cat)
  end
  
  
  
  def new
     @category = Usercategory.new
   end
  
  
  
  def create
    @category = Usercategory.new(set_params)
    @category.authuser_id = current_authuser.id
    if @category.save 
    #  Notification.new_category(@category).deliver
      redirect_to usercategory_path(@category)
    else 
      render action: 'new'
    end
  end
  
  
  
      def edit
      end

  def update
    @category.authuser_id = current_authuser.id
    if @category.update_attributes(set_params)
      redirect_to category_path(@category)
    else 
      render action: 'edit'
  end
  end
  
  
 
  def destroy
    @category.destroy
    redirect_to categories_path
  end
  
  def user_category
    @user = Authuser.find(params[:id])
    @user_categories = @user.usercategories.paginate(:page => params[:page], :per_page => 2)
  end
  
  
  
  private
    def set_params
      params[:usercategory].permit(:authuser_id, :m_category_id, :tax_type, :tax_rate,
        {:m_category_ids => []}
        )
    end
  
  
  def get_category
    @category = Usercategory.find(params[:id])
  end
  
  
  
end


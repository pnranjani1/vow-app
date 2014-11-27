class ProductsController < ApplicationController
  filter_access_to :all
 # before_filter :authenticate_authuser!
  before_filter :get_product, only: [:show, :edit, :update, :destroy]
  
  def index
  @products = Product.all
    end
  
  def show
  end
  
  def new
  @product = Product.new
  end
  
 
def create
  @product = Product.new(set_params)
  @product.authuser_id = current_authuser.id
  if @product.save 
    redirect_to product_path(@product)
    else 
      render action: 'new'
    end
  end            

  
  def edit
  end
  
  def update
    @product.authuser_id = current_authuser.id
    if @product.update_attributes(set_params)
      redirect_to product_path(@product)
    else
      render action: 'edit'
    end
  end
  
  
  def destroy
    @product.destroy
    redirect_to products_path
  end
  
  
  def product_category
    @category = Category.find_by_permalink(params[:id])
    @category_products = @category.products.paginate(:page => params[:page], :per_page => 2)
   end
  
  private
    def set_params
      params[:product].permit(:product_name, :units, :category_id)
    end
  
  def get_product
    @product = Product.find_by_permalink(params[:id])
  end
  
end

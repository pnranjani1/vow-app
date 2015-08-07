class TinNumbersController < ApplicationController
  before_filter :authenticate_authuser!
  
  def index
    @tin_numbers = TinNumber.all.order('state').paginate(:page => params[:page], :per_page => 5)
  end
  
  def new
    @tin_number = TinNumber.new
  end
  
  def create
    @tin_number = TinNumber.new(set_params)
    if @tin_number.save
      redirect_to tin_numbers_path
    else
      render action: 'new'
    end
  end
  
  def show
    @tin_number = TinNumber.find(params[:id])
  end
  
  def edit
    @tin_number = TinNumber.find(params[:id])
  end
  
  def update
    @tin_number = TinNumber.find(params[:id])
    if @tin_number.update_attributes(set_params)
      redirect_to tin_numbers_path
    else
      render action: 'edit'
    end
  end
  
  def destroy
   @tin_number = TinNumber.find(params[:id])
    @tin_number.destroy
    redirect_to tin_numbers_path
  end
  
  private
  def set_params
    params[:tin_number].permit(:state, :tin_number)
  end
end
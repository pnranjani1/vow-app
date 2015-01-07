class TaxesController < ApplicationController

  before_filter :authenticate_authuser!
  
  def index
    @taxes = Tax.all
  end
  
  def new
    @tax = Tax.new
  end
  
  def create
    @tax = Tax.new(set_params)
    if @tax.save
      redirect_to taxes_path
    else
      render action: 'new'
    end
  end
  
  def show
    @tax = Tax.find(params[:id])
  end
  
  def edit
    @tax = Tax.find(params[:id])
  end
  
  
  def update
    @tax = Tax.find(params[:id])
    if @tax.update_attributes(set_params)
      redirect_to taxes_path
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @tax = Tax.find(params[:id])
    @tax.destroy
    redirect_to taxes_path
  end


  private
  
  def set_params
    params[:tax].permit(:tax_type, :tax_rate, :tax)
  end
  
end
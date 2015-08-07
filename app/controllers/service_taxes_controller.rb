class ServiceTaxesController < ApplicationController
  before_filter :authenticate_authuser!
  
  def index
    @service_taxes = ServiceTax.all.order('service_tax_name').paginate(:page => params[:page], :per_page => 5)
  end
  
  def new
    @service_tax = ServiceTax.new
  end
  
  def create
    @service_tax = ServiceTax.new(set_params)
    if @service_tax.save
      redirect_to service_taxes_path
    else
      render action: 'new'
    end
  end
  
  def show
    @service_tax = ServiceTax.find(params[:id])
  end
  
  def edit
    @service_tax = ServiceTax.find(params[:id])
  end
  
  def update
    @service_tax = ServiceTax.find(params[:id])
    if @service_tax.update_attributes(set_params)
      redirect_to service_taxes_path
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @service_tax = ServiceTax.find(params[:id])
    @service_tax.destroy
    redirect_to service_taxes_path
  end
  
  private
  def set_params
    params[:service_tax].permit(:service_tax_name, :service_tax_rate)
  end
  
end

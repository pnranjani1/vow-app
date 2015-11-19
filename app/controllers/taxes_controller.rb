class TaxesController < ApplicationController

  before_filter :authenticate_authuser!
  
  layout_by_action [:new, :create, :show, :edit, :update, :index] => "menu"
  
  def index
  #  @taxes = Tax.all.order('tax_rate').paginate(:page => params[:page], :per_page => 5)
     @taxes = Tax.where(:authuser_id => current_authuser.id).order('created_at DESC').paginate(:page => params[:page], :per_page => 5)
  end
  
  def new
    @tax = Tax.new
  end
  
  def create
    @tax = Tax.new(set_params)
    @tax.authuser_id = current_authuser.id
    tax = Tax.where(:authuser_id => current_authuser.id).pluck(:tax_name)
    if tax.any?{|t| t.downcase.gsub(/\s/,"")[("#{params[:tax][:tax_name]}".downcase.gsub(/\s/,""))]}
      redirect_to taxes_path
      flash[:alert] = "#{params[:tax][:tax_name]} is already added"
    else
     if @tax.save     
      redirect_to taxes_path
     else
      render action: "new"
     end
    end
  end
      
=begin
    tax = Tax.where(:authuser_id => current_authuser.id).pluck(:tax)
    if tax.any?{|t| t.downcase.gsub(/\s/,"")[("#{params[:tax][:tax_type]}" + "#{params[:tax][:tax_rate]}".downcase.gsub(/\s/,""))]}
      redirect_to taxes_path
      flash[:alert] = "#{params[:tax][:tax_type] + params[:tax][:tax_rate].to_s} is already added"
    else
      @tax.tax_type = params[:tax][:tax_type].upcase
      if @tax.save
         redirect_to taxes_path
         flash[:notice] = "Tax Created Successfully!"
      else
         render action: 'new'
      end
    end 
=end
 
  
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

  def download_tax
    @taxes = Tax.where(:authuser_id => current_authuser.id)
  end



  private
  
  def set_params
    params[:tax].permit(:id, :tax_name, :tax_type, :tax_on_tax)
  end
  
end
class OtherChargesInformationsController < ApplicationController
  before_filter :authenticate_authuser!
  
  layout_by_action [:new, :create, :show, :edit, :update, :index] => "menu"
  
  def index
    @other_charges_informations = OtherChargesInformation.where(:authuser_id => current_authuser.id).order('created_at DESC').paginate(:page => params[:page], :per_page => 5)
  end
  
  def new
    @other_charges_information = OtherChargesInformation.new
  end
  
  def create
    @other_charges_information = OtherChargesInformation.new(set_params)
    @other_charges_information.authuser_id = current_authuser.id
    other_charges = OtherChargesInformation.where(:authuser_id => current_authuser.id).pluck(:other_charges)
    if other_charges.any?{|t| t.downcase.gsub(/\s/,"")[("#{params[:other_charges_information][:other_charges]}".downcase.gsub(/\s/,""))]}
      redirect_to other_charges_informations_path
      flash[:alert] = "#{params[:other_charges_information][:other_charges]} is already added"
    else
      if @other_charges_information.save
        redirect_to other_charges_informations_path
      else
        render action: 'new'
      end
    end
  end
  
  def show
    @other_charges_information = OtherChargesInformation.find(params[:id])
  end
  
  def edit
    @other_charges_information = OtherChargesInformation.find(params[:id])
  end
  
  def update
    @other_charges_information = OtherChargesInformation.find(params[:id])
    if @other_charges_information.update_attributes(set_params)
      redirect_to other_charges_informations_path
    else
      render action: "edit"
    end
  end
  
  def destroy
    @other_charges_information = OtherChargesInformation.find(params[:id])
    @other_charges_information.destroy
    redirect_to other_charges_informations_path
  end

   def download_other_charges
     @other_charges_information = OtherChargesInformation.where(:authuser_id => current_authuser.id)
  end
  
  private
  def set_params
    params[:other_charges_information].permit(:other_charges)
  end
end

class BankDetailsController < ApplicationController
  before_filter :authenticate_authuser!
  before_filter filter_resource_access
  
  
  def index
  end
  
  def new
    @bankdetail = BankDetail.new
  end
  
  def create
    @bankdetail = Bankdetail.new(set_params)
    if @bankdetail.save
      redirect_to bank_detail_path(current_authuser.id)
    else
      render action: 'new'
    end    
  end
  
  def show
    @bankdetail = Bankdetail.find(params[:id])
   end
  
  def edit
    @bankdetail = Bankdetail.find(params[:id])
  end
  
  def update
    @bankdetail = Bankdetail.find(params[:id])
    if @bankdetail.update_attributes(set_params)
      redirect_to bank_detail_path(current_authuser.id)
    else render action: 'edit'
    end
  end
  
  
  def destroy
    @bankdetail = Bankdetail.find(params[:id])
    @bankdetail.destroy
  end
  
  
  private
  
  def set_params
    params[:bank_detail].permit(:authuser_id, :bank_account_number, :ifsc_code)
  end
  
end

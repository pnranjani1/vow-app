class ReferralTypesController < ApplicationController
  
  def index
    @referral_types = ReferralType.all
  end
  
  def new
    @referral_type = ReferralType.new
  end
  
  def create
    @referral_type = ReferralType.new(set_params)
    if @referral_type.save
      redirect_to referral_types_path
    else
      redirect_to new_referral_type_path
    end
  end
  
  
  def edit
    @referral_type = ReferralType.find(params[:id])
  end
  
  def update
    @referral_type = ReferralType.find(params[:id])
    if @referral_type.update_attributes(set_params)
      redirect_to referral_types_path
    else
      redirect_to edit_referral_type_path(@referral_type.id)
    end
  end
  
  def destroy
  end
  
  private
  
  def set_params
    params[:referral_type].permit(:referral_type, :pricing)
  end
  
end

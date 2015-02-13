class EnquiryFormsController < ApplicationController
  
  
  def index
  end
  
  def new
    @enquiry_form = EnquiryForm.new
  end
  
  def create
    @enquiry_form = EnquiryForm.new(set_params)
    if @enquiry_form.save
      Notification.new_enquiry(@enquiry_form).deliver
      redirect_to '/'
      flash[:notice] = "Your Enquiry has been posted successfully, Our representative will contact you soon"
    end 
  end
  
  
  private
  def set_params
    params[:enquiry_form].permit(:name, :email, :phone_number, :comments)
   end
  
end

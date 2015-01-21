class HomePageController < ApplicationController
   
  def index
    @enquiry_form =  EnquiryForm.new
  end
end

class HomePageController < ApplicationController 
  layout_by_action [:index] => "menu1"
  
  
  def index
    @enquiry_form =  EnquiryForm.new
  end
  
  def readpdf
 #   send_file(Rails.root.join("assets", "files", "Terms of Service VatOnWheels.pdf").to_s, :disposition => "inline")
    
    send_file view_context.asset_path 'Terms of Service VatOnWheels', :disposition => "inline"
  end
  
    
  
  
end

class Notification < ActionMailer::Base
 # default from: "support@fhqpro.com"
  default from: "support@vatonwheels.com"
  
  
  def new_category(usercategory)
    @category = usercategory
    mail(:to => "nvranjani@gmail.com", :subject => "New category added to user")
  end
  
   
  
  
  def user_activated_mail(user)
    @user = user
    @url = 'edit_password_reset_url'
    mail(:to => @user.email, :subject => "Welcome to VatonWheels!! . Your Accout has been activated!")
  end


  
  def membership_end_date_reminder(user)
    @user = user
    mail(:to => @user.email, :subject => "Your account on VatonWheels will expire in 2 days, Contact your CA for further details ")
  end
  
  def new_enquiry(enquiry_form)
    @enquiry_form = enquiry_form
    mail(:to => "support@vatonwheels.com", :subject => "VatonWheels - New User Enquiry")
  end
  
  
  def new_user(user)
   @user = user
    mail(:to =>  @user.invited_by.email , :subject => "VatOnWheels – New User #{@user.name} Registration!")
  end

  
end

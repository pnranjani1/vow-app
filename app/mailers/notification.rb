class Notification < ActionMailer::Base
  default from: "support@fhqpro.com"
  
  
  def new_category(usercategory)
    @category = usercategory
    mail(:to => "nvranjani@gmail.com", :subject => "New category added to user")
  end
end

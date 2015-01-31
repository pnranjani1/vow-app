 Rails.application.configure do
    config.to_prepare do
      Devise::SessionsController.layout       "sessions"
      #Devise::RegistrationsController.layout  "layoutname"
      #Devise::ConfirmationsController.layout  "layoutname"
      #Devise::UnlocksController.layout        "layoutname"
      #Devise::PasswrodsController.layout      "layoutname"
    end
  end
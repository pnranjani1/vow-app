class RegistrationsController < Devise::RegistrationsController

  protected

    def after_update_path_for(resource)
      sign_out(resource)
      return root_url
    end
end
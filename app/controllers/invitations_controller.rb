class InvitationsController < Devise::InvitationsController

  before_filter :update_sanitized_params, only: :update
  before_filter :authenticate_authuser!

  
  
  
  # PUT /resource/invitation
  def update
    respond_to do |format|
      format.js do
        invitation_token = Devise.token_generator.digest(resource_class, :invitation_token, update_resource_params[:invitation_token])
        self.resource = resource_class.where(invitation_token: invitation_token).first
        resource.skip_password = true
        resource.update_attributes update_sanitized_params.except(:invitation_token)
        
        redirect_to root_url
      end
      format.html do
        super
       
         
      end
    end  
 
  end
  
   
  def user_edit
    @user = Authuser.find(params[:id])
  end
  
  
  
  def user_update
    @user = Authuser.find(params[:id])
    if @user.update_atributes(set_params)
      redirect_to dashboards_user_dashboard_path
    else 
      flash[:error] = "Error"
  end
  end
  


  protected

  def update_sanitized_params
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:name, :password, :password_confirmation, :invitation_token, :date_of_birth,
         {:membership_attributes => [:id, :phone_number, :membership_start_date, :membership_end_date, :membership_status, :membership_duration]},
        {:address_attributes => [:id, :address_line_1, :address_line_2, :address_line_3, :city, :country, :state]},
      {:bankdetail_attributes => [:id, :bank_account_number, :ifsc_code]},
      {:users_attributes => [:id, :tin_number, :esugam_username, :esugam_password, :client_id, :company]},
        {:permissions_attributes => [:id, :main_role_id]}
     )
    end
  end
end
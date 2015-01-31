class ApplicationController < ActionController::Base
  
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  
  before_filter {|c| Authorization.current_user = c.current_authuser}
 # before_filter :check_due_date
  # before_filter :set_current_authuser

  
 # helper_method :set_current_user
  
    def set_current_user
      Authuser.current = current_authuser
    end
  
  helper_method :current_user
  #helper_method :current_role
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  
  #will_paginate.per_page =2
  
  def current_user
    @current_user ||= Authuser.find_by_id(session[:authuser])
  end
  
  
  
 # def check_due_date
  #  if current_authuser.membership.membership_end_date > Date.today
   #   self.approved == false
   # end
  #end
  
 # def current_role
  #  session[:main_role_id] = current_authuser.main_roles.first.id
  #  @current_role = MainRole.find_by_id(session[:main_role_id])
 # end
  
  
  def permission_denied
    return dashboards_path(current_authuser) , notice: "Page Doesn't Exit"
  end
  
  
  def membership_status
  end
  
  protected
  def after_sign_in_path_for(authuser)
  #  session[:role_id] = current_authuser.main_roles.first.id
   # @current_role = MainRole.find_by_id(session[:role_id])
    #role = @current_role
    
    if current_authuser.sign_in_count == 1
      return authusers_force_password_change_path
    end
    
    
    if current_authuser.main_roles.first.role_name == "admin"
    #if current_authuser.permissions.first.main_role_id == 1
      return dashboards_admin_dashboard_path
    elsif current_authuser.main_roles.first.role_name == "client"
    #elsif current_authuser.permissions.first.main_role_id == 5
      return dashboards_client_dashboard_path
    elsif current_authuser.main_roles.first.role_name == "user"
    #  elsif  current_authuser.permissions.first.main_role_id == 6
       return dashboards_user_dashboard_path
          else 
         return root_url
     end
    end
    
    def after_sign_out_path_for(authuser)
      return new_authuser_session_path
    end
  
  def after_update_profile_path_for(authuser)
    if current_authuser.main_roles.first.role_name == "client"
      return dashboards_client_dashboard_path
    elsif current_authuser.main_roles.first.role_name == "user"
      return dashboards_user_dashboard_path
      #return user_path(current_authuser.id)
  end
  end
  
    
  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation]
    
    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update){
        |u| u.permit(registration_params << :current_password)
        }
        
      elsif params[:action] == 'create'
        devise_parameter_sanitizer.for(:signup){
          |u| u.permit(registration_params)
          }
        end
        
      #  devise_parameter_sanitizer.for(:accept_invitation)
          devise_parameter_sanitizer.for(:accept_invitation) do |u|
            u.permit(:name, :password, :password_confirmation, :invitation_token)
           end       
      end
        
      
      
end


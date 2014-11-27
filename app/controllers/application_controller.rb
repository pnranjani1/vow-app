class ApplicationController < ActionController::Base
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter {|c| Authorization.current_user = c.current_authuser}
  helper_method :current_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #will_paginate.per_page =2
  
  def current_user
    @current_user ||= Authuser.find_by_id(session[:authuser])
  end
  
  
  def permission_denied
    return dashboards_path(current_authuser) , notice: "Page Doesn't Exit"
  end
  
  protected
  def after_sign_in_path_for(authuser)
    if current_authuser.main_roles.first.role_name == "admin"
      return dashboards_admin_dashboard_path
    elsif current_authuser.main_roles.first.role_name == "Client"
      return dashboards_client_dashboard_path
    elsif current_authuser.main_roles.first.role_name == "User"
      return dashboards_user_dashboard_path
          else 
         return root_url
     end
    end
    
    def after_sign_out_path_for(authuser)
      return root_path
    end
  
  def after_update_profile_path_for(authuser)
    return user_path(current_authuser.id)
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
      end
        
      
      
end

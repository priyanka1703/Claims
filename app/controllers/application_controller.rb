class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
   before_filter :configure_permitted_parameters, if: :devise_controller?
 before_action :configure_permitted_parameters, if: :devise_controller?

 def store_location
    session[:return_to] = if request.get?
    
     request.original_url
 else
    request.referer
 end
 logger.info ("in store to : #{session[:return_to]}")
end

def redirect_back_or_default(default=root_url)
 logger.info ("Return to : #{session[:return_to]}")
 redirect_to(session.delete(:return_to) || default)
 logger.info "After deleting : #{session[:return_to]}"
end


   def after_sign_in_path_for(resource)
	
    root_path
	
  end

def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password) 
    }

	devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit( :username, :email, :password, :password_confirmation, :current_password) }

	devise_parameter_sanitizer.for(:accept_invitation) << :username

  end

end

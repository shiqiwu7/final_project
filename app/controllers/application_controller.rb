# class ApplicationController < ActionController::Base
#   include ActionController::Cookies

#   before_action :authenticate_user

#   helper_method :current_user, :logged_in?
#   helper_method :current_player

#   private

#   def current_player
#     current_user.player
#   end

#   def current_user
#     @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
#   end

#   def logged_in?
#     !!current_user
#   end

#   def authenticate_user
#     unless logged_in?
#       redirect_to login_path, alert: "You must be logged in to access this section"
#     end
#   end

#   def authorize_player
#     unless current_user&.role == "player"
#       redirect_to root_path, alert: "You must be a player to access this section"
#     end
#   end

#   def authorize_organizer
#     unless current_user&.role == "organizer"
#       redirect_to root_path, alert: "You must be an organizer to access this section"
#     end
#   end
# end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    added_attrs = [ :name, :email, :password, :password_confirmation, :remember_me, :role ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def authorize_player
    redirect_to root_path, alert: "You must be a player to access this section" unless current_user&.role == "player"
  end

  def authorize_organizer
    redirect_to root_path, alert: "You must be an organizer to access this section" unless current_user&.role == "organizer"
  end
end

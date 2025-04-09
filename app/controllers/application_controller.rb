class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

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

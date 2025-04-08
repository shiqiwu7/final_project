class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_jwt

  private

  def authenticate_jwt
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    begin
      Rails.logger.debug "JWT: Attempting to decode token"
      @decoded = JWT.decode(header, Rails.application.credentials.secret_key_base)
      Rails.logger.debug "JWT: Token decoded. User ID: #{@decoded[0]['sub']}"
      @current_user = User.find(@decoded[0]["sub"])
      Rails.logger.debug "JWT: User found: #{@current_user.email}"
      # Set current_user for Devise if you're using it
      sign_in @current_user if defined?(sign_in)
    rescue JWT::DecodeError => e
      Rails.logger.debug "JWT: Decode error: #{e.message}"
      render json: { errors: "Invalid token" }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.debug "JWT: User not found: #{e.message}"
      render json: { errors: "User not found" }, status: :unauthorized
    rescue => e
      Rails.logger.debug "JWT: Other error: #{e.class} - #{e.message}"
      render json: { errors: "Authentication failed" }, status: :unauthorized
    end
  end
end

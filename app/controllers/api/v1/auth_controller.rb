# app/controllers/api/v1/auth_controller.rb
class Api::V1::AuthController < Api::V1::BaseController
  skip_before_action :authenticate_jwt, only: [:login]
  skip_before_action :authenticate_user!, only: [ :login, :register ]

  def login
    user = User.find_by(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      token = generate_jwt_token(user)
      render json: {
        user: user.as_json(only: [ :id, :email, :created_at, :updated_at ]),
        token: token
      }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def register
    user = User.new(user_params)

    if user.save
      token = generate_jwt_token(user)
      render json: {
        user: user.as_json(only: [ :id, :email, :created_at, :updated_at ]),
        token: token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def logout
    # JWT token is invalidated on the client side
    render json: { message: "Logged out successfully" }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  def generate_jwt_token(user)
    JWT.encode({ sub: user.id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.secret_key_base)
  end
end

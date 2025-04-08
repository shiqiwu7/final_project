# class SessionsController < ApplicationController
#   skip_before_action :authenticate_user!, only: [ :new, :create ]

#   def new
#   end

#   def create
#     user = User.find_by(email: params[:email])

#     if user && user.authenticate(params[:password])
#       session[:user_id] = user.id
#       redirect_to root_path, notice: "Logged in successfully"
#     else
#       flash.now[:alert] = "Invalid email or password"
#       render :new, status: :unprocessable_entity
#     end
#   end

#   def destroy
#     session[:user_id] = nil
#     redirect_to root_path, notice: "Logged out successfully"
#   end
# end
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.valid_password?(params[:password])
      sign_in user
      redirect_to root_path, notice: "Logged in successfully"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out current_user
    redirect_to root_path, notice: "Logged out successfully"
  end
end

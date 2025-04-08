class Api::V1::UsersController < Api::V1::BaseController
  def show
    @user = current_user
    render json: @user
  end

  # Add a specific endpoint for avatar uploads
  def update_avatar
    if params[:avatar].present?
      current_user.avatar.attach(params[:avatar])
      if current_user.avatar.attached?
        render json: {
          message: "Avatar uploaded successfully",
          avatar_url: url_for(current_user.avatar)
        }, status: :ok
      else
        render json: { error: "Failed to upload avatar" }, status: :unprocessable_entity
      end
    else
      render json: { error: "No avatar file provided" }, status: :bad_request
    end
  end
end

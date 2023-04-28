class ApplicationController < ActionController::API
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    message = "You are not authorized to perform this action❗You must be an admin to perform this operation🚫"
    render json: { error: message }, status: :forbidden
  end

  private

  def authenticate_user!
    user_token = TokenServices.new.user_token(request)
    if user_token.nil?
      render json: { error: "Invalid token!" }, status: :unauthorized
    else
      user_id = user_token.user_id
      user = User.find(user_id)
      @current_user = user
    end
  end

  def current_user
    @current_user
  end
end

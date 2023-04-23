class ApplicationController < ActionController::API
  before_action :authenticate_user!

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
end

class Api::V1::NotificationsController < ApplicationController
  def index
    user_token = TokenServices.new.user_token(request)
    user_id = user_token.user_id
    @notifications = Notification.where(user_id: user_id)
    render json: { notifications: @notifications }, status: :ok
  end

  def show
    id = params[:id]
    @notification = Notification.find_by(id: id)
    render json: { notification: @notification }, status: :ok
  end

  def update
    id = params[:id]
    @notification = Notification.find_by(id: id)
    @notification.update(status: "read")
    render json: { notification: @notification }, status: :ok
  end
  
  def destroy
    id = params[:id]
    @notification = Notification.find_by(id: id)
    if @notification.nil?
      render json: { error: "Notification not found!" }, status: :not_found
    else
      @notification.destroy
      render json: { message: "Notification deleted successfully ❌" }, status: :ok
    end
  end
end

class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:create]
  load_and_authorize_resource

  def index
    @users = User.all
    render json: { users: @users }
  end

  def show
    render json: { user: @user }, status: :ok
  end

  def create
    @user = User.new(user_params)

    if @user.save
      token = @user.generate_auth_token
      render json: { message: "User created successfully 👍", token: token, user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: { message: "User updated successfully 👍", User: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: { message: "User deleted successfully ❌" }, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :email, :balance, :role, :password, :password_confirmation)
  end
end

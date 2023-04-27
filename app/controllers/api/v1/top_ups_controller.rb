class Api::V1::TopUpsController < ApplicationController
  before_action :authenticate_user!

  def create
    user_token = TokenServices.new.user_token(request)

    amount = params[:amount].to_f
    phone_number = params[:phone_number]
    user_id = user_token.user_id
    
    @top_up = TopUp.new(amount: amount, phone_number: phone_number, user_id: user_id)

    if @top_up.save
      user = User.find_by(phone_number: phone_number)
      user.update(balance: (user.balance + amount))
      render json: { message: "Top Up Successful 👍 Balance: #{user.balance}", current_balance: user.balance }, status: :created
    else
      render json: { errors: @top_up.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

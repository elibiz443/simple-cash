class Api::V1::TopUpsController < ApplicationController
  def create
    user_token = TokenServices.new.user_token(request)

    amount = params[:amount].to_f
    phone_number = params[:phone_number]
    user_id = user_token.user_id
    
    @top_up = TopUp.new(top_up_params)

    if @top_up.save
      user = User.find_by(phone_number: phone_number)
      user.update(balance: (user.balance + amount))
      render json: { message: "Top Up Successful 👍 Balance: #{user.balance}", current_balance: user.balance }, status: :created
    else
      render json: { errors: @top_up.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def top_up_params
    params.require(:top_up).permit(:amount, :phone_number, :wallet_id)
  end
end

class Api::V1::TopUpsController < ApplicationController
  before_action :authenticate_user!

  def create
    amount = params[:amount]
    phone_number = params[:phone_number]
    @top_up = TopUp.new(amount: amount, phone_number: phone_number)

    if @top_up.save
      user = User.find_by(phone_number: phone_number)
      if amount > 0
        if user.present?
          user.update(balance: (user.balance + @top_up.amount))
          render json: { message: "Top Up Successful 👍", current_balance: user.balance }, status: :created
        else
          render json: { errors: ["User not found ❌"] }, status: :unprocessable_entity
        end
      else
        render json: { errors: ["Amount Must Be More Than Zero 🚫"] }, status: :unprocessable_entity
      end
    else
      render json: { errors: @top_up.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

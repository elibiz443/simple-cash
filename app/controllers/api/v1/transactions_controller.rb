class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    amount = params[:amount].to_f
    phone_number = params[:phone_number]
    @top_up = TopUp.new(amount: amount, phone_number: phone_number)

    if @top_up.save
      user = User.find_by(phone_number: phone_number)
      user.update(balance: (user.balance + @top_up.amount))
      render json: { message: "Top Up Successful 👍", current_balance: user.balance }, status: :created
    else
      render json: { errors: @top_up.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

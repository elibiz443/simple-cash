class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    amount = params[:amount].to_f
    phone_number = params[:phone_number]
    email = params[:email]
    user_id = @current_user.id

    @transaction = Transaction.new(amount: amount, phone_number: phone_number, email: email, user_id: user_id)

    if @transaction.save
      current_user = User.find_by_id(@transaction.user_id)
      recipient = User.find_by(phone_number: phone_number) || User.find_by(email: email)

      current_user.update(balance: (current_user.balance - @transaction.amount))
      recipient.update(balance: (recipient.balance + @transaction.amount))

      render json: { message: "Transaction Successful 👍", user_balance: current_user.balance, recipient_balance: recipient.balance }, status: :created
    else
      render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

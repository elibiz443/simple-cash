class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    user_token = TokenServices.new.user_token(request)

    amount = params[:amount].to_f
    phone_number = params[:phone_number]
    email = params[:email]
    user_id = user_token.user_id

    @transaction = Transaction.new(amount: amount, phone_number: phone_number, email: email, user_id: user_id)

    if @transaction.save
      sender = User.find_by(id: user_id)
      recipient = User.find_by(phone_number: phone_number) || User.find_by(email: email)

      sender.update(balance: (sender.balance - @transaction.amount))
      recipient.update(balance: (recipient.balance + @transaction.amount))

      render json: { message: "Transaction Successful 👍", user_balance: sender.balance, recipient_balance: recipient.balance, transaction: @transaction }, status: :created
    else
      render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

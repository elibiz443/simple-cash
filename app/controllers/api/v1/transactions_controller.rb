class Api::V1::TransactionsController < ApplicationController
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      render json: { message: "Transaction Successful 👍", transaction: @transaction }, status: :created
    else
      render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :currency, :phone_number_or_email, :sending_time, :user_id)
  end
end

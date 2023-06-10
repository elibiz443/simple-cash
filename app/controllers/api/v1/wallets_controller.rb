class Api::V1::WalletsController < ApplicationController
  def create
    @wallet = Wallet.new(wallet_params)

    if @wallet.save
      render json: { message: "Wallet Created 👍", wallet: @wallet }, status: :created
    else
      render json: { errors: @wallet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def wallet_params
    params.require(:wallet).permit(:amount, :currency, :user_id)
  end
end

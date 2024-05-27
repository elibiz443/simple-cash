class Api::V1::TopUpsController < ApplicationController
  def create
    @top_up = TopUp.new(top_up_params)

    if @top_up.save
      wallet = Wallet.find_by(currency: @top_up.currency)

      render json: { 
        message: "Top Up Successful 👍 ",
        wallet: wallet,
        top_up: @top_up
      }, status: :created
    else
      render json: { errors: @top_up.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def top_up_params
    params.require(:top_up).permit(:amount, :phone_number, :currency, :user_id)
  end
end

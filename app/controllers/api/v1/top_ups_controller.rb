class Api::V1::TopUpsController < ApplicationController
  def create
    user_token = TokenServices.new.user_token(request)
    user_id = user_token.user_id

    amount = params[:amount].to_f
    phone_number = params[:phone_number]
    currency = params[:currency]

    wallet = Wallet.find_or_initialize_by(user_id: user_id, currency: currency)

    if wallet.new_record?
      wallet.balance = amount
      wallet.save!
    else
      wallet.update!(balance: (wallet.balance + amount))
    end

    @top_up = TopUp.new(top_up_params)

    if @top_up.save
      render json: { 
        message: "Top Up Successful 👍 ",
        wallet: wallet
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

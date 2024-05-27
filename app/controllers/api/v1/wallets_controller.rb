class Api::V1::WalletsController < ApplicationController
  before_action :set_wallet, only: [:show, :update, :destroy]

  def index
    @wallets = Wallet.where(user_id: current_user)
    render json: { wallets: @wallets }, status: :ok
  end

  def show
    if @wallet.user_id == current_user.id
      render json: { wallet: @wallet }, status: :ok
    else
      render json: { message: "You can only view your wallet" }, status: :ok
    end
  end

  def create
    @wallet = Wallet.new(wallet_params)

    if @wallet.save
      render json: { message: "Wallet Created 👍", wallet: @wallet }, status: :created
    else
      render json: { errors: @wallet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_wallet
    @wallet = Wallet.find_by(id: params[:id])
    render json: { error: 'Wallet not found' }, status: :not_found unless @wallet
  end

  def wallet_params
    params.require(:wallet).permit(:amount, :currency, :user_id)
  end
end

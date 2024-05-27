class TopUp < ApplicationRecord
  before_create :verify_user_and_current_user
  before_create :create_wallet

  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0, message: "must be present or greater than 0❗" }
  validates :currency, presence: true

  default_scope { order(created_at: :desc) }

  private

  def verify_user_and_current_user
    user = User.find_by(id: user_id)

    unless user && user.phone_number == phone_number
      errors.add(:user, "Invalid 🚫 You can only top up to your number❗")
      throw(:abort)
    end
  end

  def create_wallet
    wallet = Wallet.find_or_initialize_by(user_id: user_id, currency: currency)

    if wallet.new_record?
      wallet.balance = amount
      wallet.save!
    else
      wallet.update!(balance: (wallet.balance + amount))
    end
  end
end

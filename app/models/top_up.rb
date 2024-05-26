class TopUp < ApplicationRecord
  before_create :verify_user_and_current_user

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
end

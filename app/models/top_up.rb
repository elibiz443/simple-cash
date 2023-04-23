class TopUp < ApplicationRecord
  before_create :verify_user
  before_create :verify_current_user

  belongs_to :user

  validates :amount, presence: true, numericality: { 
    greater_than: 0, message: "must be present or greater than 0❗" }

  def verify_user
    unless User.exists?(phone_number: self.phone_number)
      errors.add(:phone_number, "does not exist 🚫")
      throw(:abort)
    end
  end

  def verify_current_user
    unless user.id == user_id && user.phone_number == phone_number
      errors.add(:user, "invalid 🚫 You can only top up to your number❗")
      throw(:abort)
    end
  end
end

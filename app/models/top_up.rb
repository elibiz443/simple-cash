class TopUp < ApplicationRecord
  before_create :verify_user

  validates :amount, presence: true, numericality: { 
    greater_than: 0, message: "must be present or greater than 0❗" }

  def verify_user
    unless User.exists?(phone_number: self.phone_number)
      errors.add(:phone_number, "does not exist 🚫")
      throw(:abort)
    end
  end
end

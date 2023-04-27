class Transaction < ApplicationRecord
  before_create :capture_sending_time
  before_create :verify_recipient_user
  before_create :verify_amount
  before_create :block_self_transfer

  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0, message: "must be present or greater than 0❗" }
  validates_format_of :phone_number_or_email, with: /\A(?:\d{10}|[^\s@]+@[^\s@]+\.[^\s@]+)\z/i, message: "must be a valid phone number or email address❗"

  def capture_sending_time
    self.sending_time = Time.now
  end

  def verify_recipient_user
    unless User.exists?(phone_number: self.phone_number) || User.exists?(email: self.email)
      errors.add(:phone_number_or_email, "does not exist 🚫")
      throw(:abort)
    end
  end

  def block_self_transfer
    unless user.phone_number != self.phone_number && user.email != self.email
      errors.add(:phone_number_or_email, "incorrect 🚫 you cannot transfer to self ❌")
      throw(:abort)
    end
  end

  def verify_amount
    current_balance = User.find_by_id(self.user_id).balance
    unless current_balance > self.amount
      errors.add(:amount, "more than the existing balance ❌")
      throw(:abort)
    end
  end
end

class Transaction < ApplicationRecord
  before_create :capture_sending_time
  before_create :verify_recipient_user
  before_create :verify_amount
  before_create :block_self_transfer
  before_create :update_wallet_balances
  after_save :send_notification
  after_save :send_mail

  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0, message: "must be present or greater than 0❗" }
  validates :phone_number_or_email, presence: true
  validates :currency, presence: true

  default_scope { order(created_at: :desc) }

  private

  def capture_sending_time
    self.sending_time = Time.zone.now
  end

  def verify_recipient_user
    unless User.exists?(phone_number: phone_number_or_email) || User.exists?(email: phone_number_or_email)
      errors.add(:phone_number_or_email, "does not exist 🚫")
      throw(:abort)
    end
  end

  def block_self_transfer
    unless user.phone_number != phone_number_or_email && user.email != phone_number_or_email
      errors.add(:phone_number_or_email, "incorrect 🚫 you cannot transfer to self ❌")
      throw(:abort)
    end
  end

  def verify_amount
    sender_wallet_balance = Wallet.find_by(user_id: user_id, currency: currency).balance
    unless sender_wallet_balance > amount
      errors.add(:amount, "more than the existing balance ❌")
      throw(:abort)
    end
  end

  def sender
    User.find_by_id(user_id)
  end

  def recipient
    User.find_by(phone_number: phone_number_or_email) || 
    User.find_by(email: phone_number_or_email)
  end

  def notification_info
    "#{SecureRandom.hex(3).upcase + Time.now.strftime("%d%m%y")} 
    Confirmed. You have received Ksh#{amount} from 
    #{sender.first_name + " " + sender.last_name} #{sender.phone_number} 
    on #{(Time.now).strftime("%d/%m/%y")} at #{(Time.now).strftime("%H:%M %p")}"
  end

  def create_recipient_wallet
    wallet = Wallet.find_or_initialize_by(user_id: recipient.id, currency: currency)

    if wallet.new_record?
      wallet.balance = amount
      wallet.save!
    else
      wallet.update!(balance: (wallet.balance + amount))
    end
  end

  def update_wallet_balances
    sender_wallet = Wallet.find_by(user_id: user_id, currency: currency)

    sender_wallet.update(balance: (sender_wallet.balance - amount))
    create_recipient_wallet
  end

  def send_notification
    Notification.create(detail: "#{notification_info}", user_id: recipient.id)
  end

  def send_mail
    MailServices.new.send_mail(notification_info, recipient.email)
  end
end

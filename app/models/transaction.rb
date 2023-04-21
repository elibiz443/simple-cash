class Transaction < ApplicationRecord
  before_create :capture_sending_time

  belongs_to :user
  validates :amount, presence: true
  validates :phone_number, presence: true, :numericality => true, :length => { :minimum => 9, :maximum => 13 }, unless: :email
  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}, unless: :phone_number

  def capture_sending_time
    self.sending_time = Time.now
  end
end

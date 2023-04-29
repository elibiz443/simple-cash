class User < ApplicationRecord
  has_one :auth_token, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :top_ups, dependent: :destroy
  has_many :reports, dependent: :destroy

  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true

  default_scope {order('users.created_at ASC')}

  def generate_auth_token
    secret_key = Rails.application.secret_key_base
    payload = { user_id: self.id }
    token = JWT.encode(payload, secret_key)
    auth_token = AuthToken.find_or_create_by(user: self) do |token|
      token.token_digest = token
    end
    auth_token.update(token_digest: token)
    token
  end

  def self.find_by_token(token)
    begin
      decoded_payload = JWT.decode(token, Rails.application.secret_key_base)[0]
      User.find(decoded_payload["user_id"])
    rescue JWT::DecodeError
      nil
    end
  end

  def invalidate_token
    auth_token&.destroy
    update(auth_token: nil)
  end

  def admin?
    role == "admin"
  end
end

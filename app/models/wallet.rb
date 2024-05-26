class Wallet < ApplicationRecord
  belongs_to :user
  validates :currency, presence: true
  validates :balance, presence: true

  default_scope { order(created_at: :desc) }
end

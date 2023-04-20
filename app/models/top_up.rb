class TopUp < ApplicationRecord
  validates :phone_number, presence: true
  validates :amount, presence: true
end

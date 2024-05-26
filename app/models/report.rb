class Report < ApplicationRecord
  belongs_to :user
  has_many :transactions, through: :user

  validates :start_date, presence: true, inclusion: { in: (Time.zone.now - 120.days)..(Time.zone.now - 8.days), message: "must be at least a week ago, and not more than past 120 days❗" }
  validates :end_date, presence: true, inclusion: { in: (Time.zone.now - 7.days)..Time.zone.now, message: "must be at most a week ago, and not more than the current time❗" }

  default_scope { order(created_at: :desc) }
end

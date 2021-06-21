class Micropost < ApplicationRecord
  belongs_to :user
  # ensures the microposts come out most recent post first
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end

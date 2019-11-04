class Micropost < ApplicationRecord
  belongs_to :user
  #ensures the microposts to come out in reverse order of when they were created so that the most recent post is first
  #a Proc (procedure) or lambda, which is an anonymous function (see 13.17)
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end

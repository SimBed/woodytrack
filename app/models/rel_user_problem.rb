class RelUserProblem < ApplicationRecord
  belongs_to :user
  belongs_to :problem
  scope :tops, -> { where("highpoint = ?", 'top') }
end

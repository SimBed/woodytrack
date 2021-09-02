# include ActionView::Helpers::DateHelper
class RelUserProblem < ApplicationRecord

  belongs_to :user
  belongs_to :problem
  # scope :tops, -> { where("highpoint = ?", 'top') }

  def self.tops_feed
    where("highpoint = ?", 'top').order(updated_at: :desc).take(10)
  end

end

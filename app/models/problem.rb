class Problem < ApplicationRecord
  has_many :rel_user_problems, dependent: :destroy
  has_many :users, through: :rel_user_problems
  validates :name,  presence: true, length: { maximum: 26 },
                    uniqueness: { case_sensitive: false }

  def rel(user)
    rel_user_problems.find_by(user_id: user.id)
  end

  def status(user)
    return 'not tried' if rel_user_problems.find_by(user_id: user.id).nil?
    return 'sent' if rel_user_problems.find_by(user_id: user.id).highpoint == 'top'

    'project'
  end
end

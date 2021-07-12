class Problem < ApplicationRecord
  has_many :rel_user_problems, dependent: :destroy
  has_many :users, through: :rel_user_problems
  scope :order_by_givengrade, -> { order(givengrade: :desc) }
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

 def Problem.grades(grade)
   Problem.all.where(givengrade: grade)
 end

 def sent?(user)
   return true if self.status(user) == 'sent'
   return false
 end

 def averagegrade
   gradeArray = Rails.application.config_for(:climbinginfo)["grades"]
   userGrades = rel_user_problems.map { |r| r.suggestedgrade}
   return if userGrades.empty?
   avIndex = userGrades.inject(0) { |accum, i| accum + gradeArray.index(i) }.to_f / userGrades.size
   gradeArray[avIndex.round]
 end

end

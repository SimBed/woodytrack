class Problem < ApplicationRecord
  has_many :rel_user_problems, dependent: :destroy
  has_many :users, through: :rel_user_problems
  scope :order_by_givengrade_asc, -> { order(givengrade: :asc) }
  scope :order_by_givengrade_desc, -> { order(givengrade: :desc) }
  scope :order_by_name, -> { order(name: :asc) }
  scope :order_by_setter, -> { order(setter: :asc) }
  scope :order_by_random, -> { order('RANDOM()') }
  validates :name,  presence: true, length: { maximum: 40 },
                    uniqueness: { case_sensitive: false }

  def rel(user)
    rel_user_problems.find_by(user_id: user.id)
  end

  def status(user)
    return 'untried' if rel_user_problems.find_by(user_id: user.id).nil?
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

 def suggestedgrade(user)
   return givengrade if rel_user_problems.find_by(user_id: user.id).nil?
   rel_user_problems.find_by(user_id: user.id).suggestedgrade
 end
end

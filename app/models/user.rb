class User < ApplicationRecord
  has_many :rel_user_problems, dependent: :destroy
  has_many :problems, through: :rel_user_problems
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 40 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  scope :order_by_name, -> { order(name: :asc) }

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update(remember_digest: User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update(remember_digest: nil)
  end

  # Activates an account.
  def activate
    update(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Returns a user's status feed.
  # def feed
  #   # initial code -  works but less efficient and therefore less scaleable than the 'raw SQL approach'
  #   # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
  #   following_ids = "SELECT followed_id FROM relationships
  #                    WHERE  follower_id = :user_id"
  #   Micropost.where("user_id IN (#{following_ids})
  #                    OR user_id = :user_id", user_id: id)
  # end

  def highest_grade_topped
    return nil if problems.empty?

    Problem.joins("INNER JOIN rel_user_problems on rel_user_problems.problem_id = problems.id
                   INNER JOIN users on users.id = rel_user_problems.user_id")
                   .where("users.id=#{id}")
                   .where("rel_user_problems.highpoint = ?", 'top')
                   .order('givengrade DESC')&.first&.givengrade
  end

  def sends_at_grade(grade)
    return nil if grade.nil?

    Problem.joins("INNER JOIN rel_user_problems on rel_user_problems.problem_id = problems.id
                   INNER JOIN users on users.id = rel_user_problems.user_id")
                   .where("users.id=#{id}")
                   .where("rel_user_problems.highpoint = ?", 'top')
                   .where("givengrade = ?", grade).count
  end

  def whack_points(multiplier = 2)
    grade_array = Rails.application.config_for(:climbinginfo)["grades"]
    # remove 'proj'
    grade_array.pop
    whack_points = 0
    grade_index = 0
    grade_array.each do |grade|
      add = sends_at_grade(grade) * multiplier ** grade_index
      whack_points += add
      grade_index += 1
    end
    whack_points
  end

  def hasclimbed?
    return false if problems.empty?
    true
  end

  def topouts
    rel_user_problems.where(highpoint: 'top').count
  end

  def position
    return nil if problems.empty?
    users = User.where(activated: true).joins(:rel_user_problems).distinct
    users_by_points = users.to_a.sort_by { |u| -u.whack_points }
    users_by_points.index(self) + 1
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end

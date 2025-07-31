class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'Whack - Account activation'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Whack - Password reset'
  end

  def profile_active
    mail to: 'woodytrackharrow@gmail.com', subject: 'Whack - Profile Activated Alert'
  end

end

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        action_when_activated(user)
      else
        flash_and_redirect_not_activated
      end
    else
      action_when_invalid
    end
  end

  def destroy
    log_out if logged_in?
    clear_session(:filter_grade, :filter_status)    
    redirect_to root_url
  end

  private

  def action_when_activated(user)
    log_in user
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    redirect_back_or problems_path
  end

  def flash_and_redirect_not_activated
    message  = 'Account not activated. '
    message += 'Check your email for the activation link.'
    flash[:warning] = message
    redirect_to root_url
  end

  def action_when_invalid
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end
end

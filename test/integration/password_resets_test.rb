require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:amala)
  end

  test 'password resets (email validity)' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, params: { password_reset: { email: '' } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'password resets (details incorrect)' do
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    # Inactive user
    user.toggle(:activated).save
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle(:activated).save
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
  end

  test 'password resets (details correct)' do
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    user = assigns(:user)
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: 'foobaz',
                            password_confirmation: 'barquux' } }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: '',
                            password_confirmation: '' } }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: 'foobaz',
                            password_confirmation: 'foobaz' } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to problems_path
    assert_nil user.reload.reset_digest
  end

  test 'expired token' do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @user.email } }

    @user = assigns(:user)
    @user.update(reset_sent_at: 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password: 'foobar',
                            password_confirmation: 'foobar' } }
    assert_response :redirect
    follow_redirect!
    assert_not flash.empty?
    assert_match 'expired', response.body
  end
end

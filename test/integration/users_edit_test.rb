require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }

    assert_template 'users/edit'
    assert_select 'div.alert.alert-danger', text: 'The form contains 4 errors.'
  end

  test 'successful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    # edit_user_path(@user) url will get stored in forwarding_url session
    # (through users controller callback on edit method and sessions_helper store_location method)
    log_in_as(@user)
    # due to sessions_helpers store_location and redirect_back_or methods
    assert_redirected_to edit_user_url(@user)
    name  = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
    # confirms friendly forwarding only applies the first time
    log_in_as(@user)
    # sessions_helpers redirect_back_or method (called in action_when_activated
    # in session controller's create method) deletes the forwarding_url session
    assert_redirected_to problems_path
  end
end

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @simbed = users(:simbed)
    @amala = users(:amala)
    @aadrak = users(:aadrak)
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@amala)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@amala), params: { user: { name: @amala.name,
                                               email: 'amala@squeak.com' } }
    assert_not flash.empty?
    assert_not_equal 'amala@squeak.com', @amala.reload.email
    assert_redirected_to login_url
  end

  test 'should redirect update when logged in as wrong person' do
    log_in_as(@aadrak)
    patch user_path(@amala), params: { user: { name: @amala.name,
                                               email: 'amala@squeak.com' } }
    assert_not_equal 'amala@squeak.com', @amala.reload.email
    assert_redirected_to root_url
  end

  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as(@amala)
    assert_not @amala.admin?
    patch user_path(@amala), params: {
      user: { password: 'password',
              password_confirmation: 'password',
              admin: true }
    }
    assert_not @amala.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@amala)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@amala)
    assert_no_difference 'User.count' do
      delete user_path(@aadrak)
    end
    assert_redirected_to root_url
  end
end

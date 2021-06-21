require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'layout links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 0
    assert_select 'a[href=?]', problems_path, count: 0
    assert_select 'a[href=?]', rel_user_problems_path, count: 0
    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', signup_path

    get signup_path
    assert_template 'users/new'
    assert_select 'title', 'Sign up | Whack'

    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 0
    assert_select 'a[href=?]', problems_path
    assert_select 'a[href=?]', rel_user_problems_path
    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', signup_path, count: 0
  end
end

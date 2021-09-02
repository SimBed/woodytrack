require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @amala = users(:amala)
  end

  test 'nav bar links on homepage' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 1
    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a[href=?]', problems_path, count: 1
    assert_select 'a[href=?]', league_table_path, count: 1
    # include li to be more specific as link to user may appear in the league table
    assert_select 'li.nav-item a[href=?]', user_path(@amala), count: 0
    assert_select 'a[href=?]', edit_user_path(@amala), count: 0
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', login_path, count: 1
    assert_select 'a[href=?]', signup_path, count: 1
  end

  test 'nav bar links once logged in' do
    log_in_as(@amala)
    follow_redirect!
    assert_template 'problems/index'
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 1
    assert_select 'a[href=?]', users_path, count: 1
    assert_select 'a[href=?]', problems_path, count: 1
    assert_select 'a[href=?]', league_table_path, count: 1
    assert_select 'li.nav-item a[href=?]', user_path(@amala), count: 1
    assert_select 'a[href=?]', edit_user_path(@amala), count: 1
    assert_select 'a[href=?]', logout_path, count: 1
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', signup_path, count: 0
  end
end

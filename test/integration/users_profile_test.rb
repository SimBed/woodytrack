require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @non_admin = users(:archer)
  end

  test 'profile display' do
    log_in_as(@non_admin)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    # assert_select 'h1', text: @user.name
    assert_match @user.name, response.body
    assert_select 'h1>img.gravatar'
  end
end

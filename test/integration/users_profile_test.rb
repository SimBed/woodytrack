require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @amala = users(:amala)
    @aadrak = users(:aadrak)
  end

  test 'profile display' do
    log_in_as(@amala)
    get user_path(@aadrak)
    assert_template 'users/show'
    assert_select 'title', full_title(@aadrak.name)
    assert_match @aadrak.name, response.body
    assert_select 'h1>img.gravatar'
    assert_select 'div', text: '6a x1'
  end
end

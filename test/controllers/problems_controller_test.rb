require 'test_helper'

class ProblemsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @simbed = users(:simbed)
    @amala = users(:amala)
    @babycakes = problems(:babycakes)
  end

  test 'should get index logged in or not' do
    get problems_path
    assert_response :success
  end

  test 'should redirect new when not logged in as admin' do
    log_in_as(@amala)
    get new_problem_path
    assert_redirected_to root_url
  end

  test 'should redirect show when not logged in' do
    get problem_path(@babycakes)
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in as admin' do
    log_in_as(@amala)
    get edit_problem_path(@babycakes)
    assert_redirected_to root_url
  end

  test 'should redirect create when not logged in as admin' do
    log_in_as(@amala)
    assert_no_difference 'Problem.count' do
      post problems_path, params: { problem: { name: 'test_problem', givengrade: '6a' } }
    end
    assert_redirected_to root_url
  end

  test 'should redirect update when not logged in as admin' do
    log_in_as(@amala)
    patch problem_path(@babycakes), params: { problem: { name: @babycakes.name,
                                                         givengrade: @babycakes.givengrade } }
    assert_redirected_to root_url
  end

  test 'should redirect destroy when not logged in as admin' do
    log_in_as(@amala)
    assert_no_difference 'Problem.count' do
      delete problem_path(@babycakes)
    end
    assert_redirected_to root_url
  end
end

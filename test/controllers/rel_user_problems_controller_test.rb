require 'test_helper'

class RelUserProblemsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @simbed = users(:simbed)
    @amala = users(:amala)
    @aadrak = users(:aadrak)
    @babycakes = problems(:babycakes)
    @amalababy = rel_user_problems(:amalababy)
  end

  test 'should redirect new when not logged in' do
    get new_rel_user_problem_path
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in as correct user' do
    log_in_as(@aadrak)
    get edit_rel_user_problem_path(@amalababy)
    assert_redirected_to root_url
  end

  test 'should redirect create when not logged in as correct user' do
    log_in_as(@amala)
    assert_no_difference 'Problem.count' do
      post rel_user_problems_path,
           params: {
             rel_user_problem: { user_id: ActiveRecord::FixtureSet.identify(:aadrak),
                                 problem_id: ActiveRecord::FixtureSet.identify(:babycakes) }, highpoint: 'top'
           }
    end
    assert_redirected_to root_url
  end

  test 'should redirect update when not logged in as correct user' do
    log_in_as(@aadrak)
    patch rel_user_problem_path(@amalababy), params: { rel_user_problem: { suggestedgrade: '6c' } }
    assert_equal @amalababy.reload.suggestedgrade, '6b+'
    assert_redirected_to root_url
  end

  test 'should redirect destroy when not logged in as correct user' do
    log_in_as(@aadrak)
    assert_no_difference 'RelUserProblem.count' do
      delete rel_user_problem_path(@amalababy)
    end
    assert_redirected_to root_url
  end
end

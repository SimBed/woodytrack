require 'test_helper'

class RelUserProblemTest < ActiveSupport::TestCase
  def setup
    @rel_user_problem = RelUserProblem.new(user_id: ActiveRecord::FixtureSet.identify(:amala),
                                           problem_id: ActiveRecord::FixtureSet.identify(:excaliboy),
                                           suggestedgrade: '6b', highpoint: 'hill', dohp: '2021-10-09',
                                           firsttry: '2021-10-09', rating: 3, comment: 'wonderful')
  end

  test 'should be valid' do
    assert @rel_user_problem.valid?
  end

  # test 'count tops' do
  #   assert_equal 3, RelUserProblem.tops.count
  # end
end

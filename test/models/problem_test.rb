require 'test_helper'

class ProblemTest < ActiveSupport::TestCase
  def setup
    @problem = Problem.new(name: 'warmup', givengrade: '6a', setter: 'unknown')
  end

  test 'should be valid' do
    assert @problem.valid?
  end

  test 'name should be present' do
    @problem.name = '     '
    assert_not @problem.valid?
  end

  test 'name should not be too long' do
    @problem.name = 'a' * 27
    assert_not @problem.valid?
  end

  test 'name should be unique' do
    duplicate_problem = @problem.dup
    duplicate_problem.name = @problem.name.upcase
    @problem.save
    assert_not duplicate_problem.valid?
  end
end

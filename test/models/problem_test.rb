require 'test_helper'

class ProblemTest < ActiveSupport::TestCase
  def setup
    @problem = Problem.new(name: 'warmup', givengrade: '6a', setter: 'unknown')
    @babycakes = problems(:babycakes)
    @soberingsundaes = problems(:soberingsundaes)
    @crossing = problems(:crossing)
    @amala = users(:amala)
    @aadrak = users(:aadrak)
  end

  test 'should be valid' do
    assert @problem.valid?
  end

  test 'name should be present' do
    @problem.name = '     '
    assert_not @problem.valid?
  end

  test 'name should not be too long' do
    @problem.name = 'a' * 41
    assert_not @problem.valid?
  end

  test 'name should be unique' do
    duplicate_problem = @problem.dup
    duplicate_problem.name = @problem.name.upcase
    @problem.save
    assert_not duplicate_problem.valid?
  end

  test 'associated relationships with problems should be destroyed' do
    assert_difference 'RelUserProblem.count', -3 do
      @babycakes.destroy
    end
  end

  test 'status snd sent? method' do
    assert_equal 'sent', @soberingsundaes.status(@amala)
    assert_equal 'project', @babycakes.status(@amala)
    assert_equal 'not tried', @crossing.status(@amala)
    assert @soberingsundaes.sent?(@amala)
    assert_not @babycakes.sent?(@amala)
    assert_not @crossing.sent?(@amala)
  end

  test 'averagegrade method' do
    assert_equal '6b', @babycakes.averagegrade
    assert_equal '6c+', @soberingsundaes.averagegrade
    assert_nil @crossing.averagegrade
  end

  test 'suggestedgrade method' do
    assert_equal '6b+', @babycakes.suggestedgrade(@amala)
    assert_equal '8a', @crossing.suggestedgrade(@aadrak)
  end
end

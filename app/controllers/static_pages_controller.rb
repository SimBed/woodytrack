class StaticPagesController < ApplicationController
  def home
    @grade = Problem.distinct.pluck(:givengrade).sort!

    @users = User.where(activated: true).joins(:rel_user_problems).distinct
    @users_by_wp_position = @users.to_a.sort_by { |u| -u.whack_points }.take(3)
    @users = @users_by_wp_position
    @tops_feed = RelUserProblem.tops_feed
    end
end

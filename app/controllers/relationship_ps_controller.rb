class RelationshipPsController < ApplicationController
  def index
    @problems = current_user.problems
  end
end

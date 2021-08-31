class RelUserProblemsController < ApplicationController
  before_action :set_rel, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create]
  before_action :correct_user_creating, only: [:create]


  #helper_method :sort_column, :sort_direction

  def new
    @problem = Problem.find(params[:problem_id])
    @rel_user_problem = RelUserProblem.new
  end

  def edit; end

  def create
    # 2 ways to trigger create method - 1) through web when following user, 2) when seeding
    # if params[:commit] == 'Follow'
    #   @problem = Problem.find(params[:problem_id])
    #   current_user.probfollow(@problem)
    #   redirect_to problems_path
    #   flash[:success] = "#{@problem.name} now followed! Edit from My Problems."
    # else
      @rel_user_problem = RelUserProblem.new(rel_params)
      # first part of if clause prevents 1 user creating a relationship for another user
      if @rel_user_problem.save
        @problem = Problem.find(params[:rel_user_problem][:problem_id])
        redirect_to problems_path
        flash[:success] = "#{@problem.name} Tracked"
      else
        render :new
      end
    #end
  end

  def update
    if @rel_user_problem.update(rel_params)
      redirect_to problems_path
      flash[:success] = "#{@problem.name} Tracking Updated"
    else
      render :edit
    end
  end

  def destroy
    @rel_user_problem.destroy
    flash[:success] = "#{@problem.name} No Longer Tracked"
    redirect_to rel_user_problems_path
  end

  private

  def set_rel
    @rel_user_problem = RelUserProblem.find(params[:id])
    # so name can be included in flash messages
    @problem = Problem.find_by(id: @rel_user_problem.problem_id)
    # @probname = Problem.find_by(id: @rel_user_problem.problem_id).name
  end

  def rel_params
    params.require(:rel_user_problem).permit(:user_id, :problem_id, :suggestedgrade, :highpoint, :dohp, :firsttry,
                                             :rating, :comment)
  end

  # Confirms the correct user. (So 1 user can't interfere with another user's relationship with a problem)
  def correct_user
    @rel_user_problem = RelUserProblem.find(params[:id])
    @user = User.find(@rel_user_problem.user_id)
    redirect_to(root_url) unless current_user?(@user)
  end

  def correct_user_creating
    # prevents 1 user creating a relationship for another user
    redirect_to(root_url) unless params[:rel_user_problem][:user_id] == current_user.id.to_s
  end

  # def sort_column
  #   # params[:sort] || "name"
  #   (RelUserProblem.column_names + Problem.column_names).include?(params[:sort]) ? params[:sort] : 'name'
  # end
  #
  # def sort_direction
  #   # params[:direction] || "asc"
  #   # additional code provides robust sanitisation of what goes into the order clause
  #   %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  # end
end

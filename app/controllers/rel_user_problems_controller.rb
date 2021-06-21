class RelUserProblemsController < ApplicationController
  before_action :set_rel, only: [:edit, :update, :destroy]
  ##  before_action :admin_user,     only: [:new, :edit, :update, :destroy]

  helper_method :sort_column, :sort_direction

  def index
    return unless logged_in?

    @problems = current_user.problems.order("#{sort_column} #{sort_direction}", :name).paginate(page: params[:page],
                                                                                                per_page: 10)
  end

  def new
    @problem = Problem.find(params[:problem_id])
    current_user.probfollow(@problem)
    @rel_user_problem = RelUserProblem.find_by(user_id: current_user.id, problem_id: params[:problem_id])
  end

  def edit; end

  def create
    # 2 ways to trigger create method - 1) through web when following user, 2) when seeding
    if params[:commit] == 'Follow'
      @problem = Problem.find(params[:problem_id])
      current_user.probfollow(@problem)
      redirect_to problems_path
      flash[:success] = "#{@problem.name} now followed! Edit from My Problems."
    else
      @rel_user_problem = RelUserProblem.new(rel_params)
      if @rel_user_problem.save
        redirect_to rel_user_problems_path
        flash[:success] = 'New Problem Followed! Edit from My Problems.'
      else
        render :new
      end
    end
  end

  def update
    if @rel_user_problem.update(rel_params)
      redirect_to problems_path
      flash[:success] = "#{@probname} updated"
    else
      render :edit
    end
  end

  def destroy
    @rel_user_problem.destroy
    flash[:success] = "#{@probname} no longer followed"
    redirect_to rel_user_problems_path
  end

  private

  def set_rel
    @rel_user_problem = RelUserProblem.find(params[:id])
    # so name can be included in flash messages
    @probname = Problem.find_by(id: @rel_user_problem.problem_id).name
  end

  def rel_params
    params.require(:rel_user_problem).permit(:user_id, :problem_id, :suggestedgrade, :highpoint, :dohp, :firsttry,
                                             :rating, :comment)
  end

  def sort_column
    # params[:sort] || "name"
    (RelUserProblem.column_names + Problem.column_names).include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    # params[:direction] || "asc"
    # additional code provides robust sanitisation of what goes into the order clause
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end

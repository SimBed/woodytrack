class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :edit, :update, :destroy]
  before_action :admin_user,     only: [:new, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show]

  helper_method :sort_column, :sort_direction

  def index
    #    @problems = Problem.all.order(params[:sort], :name).paginate(page: params[:page],per_page: 10)
    @problems = Problem.all.order("#{sort_column} #{sort_direction}", :givengrade).paginate(page: params[:page],
                                                                                            per_page: 20)
  end

  def new
    @problem = Problem.new
  end

  def show
    @problems = Problem.all.map { |p| [p.name, p.id, { 'data-showurl' => problem_url(p.id) }] }
    @rel_user_problem = RelUserProblem.find_by(user_id: current_user.id, problem_id: params[:id])
  end

  # GET /problems/1/edit
  def edit; end

  # POST /problems
  # POST /problems.json
  def create
    @problem = Problem.new(problem_params)

    if @problem.save
      redirect_to problems_path
      flash[:success] = "New problem, #{@problem.name} added!"
    else
      render :new
    end
  end

  def update
    if @problem.update(problem_params)
      redirect_to problems_path
      flash[:success] = "#{@problem.name} updated"
    else
      render :edit
    end
  end

  def destroy
    @problem.destroy
    flash[:success] = "#{@problem.name} deleted"
    redirect_to problems_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_problem
    @problem = Problem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def problem_params
    params.require(:problem).permit(:name, :givengrade, :setter)
  end

  def sort_column
    # params[:sort] || "name"
    Problem.column_names.include?(params[:sort]) ? params[:sort] : 'givengrade'
  end

  def sort_direction
    # params[:direction] || "asc"
    # additional code provides robust sanitisation of what goes into the order clause
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end

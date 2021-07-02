class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :edit, :update, :destroy]
  before_action :admin_user,     only: [:new, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show]

  helper_method :sort_column, :sort_direction

  def index
    case sort_column
    when 'name', 'givengrade'
      # if Player.column_names.include?(sort_column)
      @problems = Problem.all.order("#{sort_column} #{sort_direction(direction: 'asc')}", :givengrade).paginate(page: params[:page],
                                                                                                                per_page: 20)
    when 'status'
      # @problems = Problem.all.to_a.sort_by { |p| p.status(current_user) }.paginate(page: params[:page], per_page: 20)
      # @problems.reverse!.paginate(page: params[:page], per_page: 20) if sort_direction == 'desc'
    end

    respond_to do |format|
      format.html
      format.js
    end
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

  def summary
    @grade = Problem.distinct.pluck(:givengrade).sort!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_problem
    @problem = Problem.find(params[:id])
  end

  # Never trust parameters from the internet, only allow the white list through.
  def problem_params
    params.require(:problem).permit(:name, :givengrade, :setter)
  end

  def sort_column
    %w[name givengrade setter].include?(params[:sort]) ? params[:sort] : 'givengrade'
  end

end

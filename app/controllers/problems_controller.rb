class ProblemsController < ApplicationController
  before_action :initialize_sort, only: :index
  before_action :set_problem, only: [:show, :edit, :update, :destroy]
  before_action :admin_user,     only: [:new, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show]

  helper_method :sort_column, :sort_direction

  def index
    handle_search
    #@problems = @problems.send("order_by_#{session[:sort_option]}").paginate(page: params[:page], per_page: 10)
    @grade = Problem.distinct.pluck(:givengrade).sort!
    @status = %w[not\ tried sent project]

    case session[:sort_option]
    when 'givengrade_asc', 'givengrade_desc', 'name', 'setter', 'random'
      @problems = @problems.send("order_by_#{session[:sort_option]}").paginate(page: params[:page], per_page: 20)
    when 'suggestedgrade_asc'
      @problems = @problems.to_a.sort_by { |p| p.suggestedgrade(current_user) }.paginate(page: params[:page], per_page: 20)
    when 'suggestedgrade_desc'
      @problems = @problems.to_a.sort_by { |p| p.suggestedgrade(current_user) }.reverse!.paginate(page: params[:page], per_page: 20)
    when 'status_asc'
      @problems = @problems.to_a.sort_by { |p| p.status(current_user) }.paginate(page: params[:page], per_page: 20)
    when 'status_desc'
      @problems = @problems.to_a.sort_by { |p| p.status(current_user) }.reverse!.paginate(page: params[:page], per_page: 20)
    end

#givengrade_asc
    # case sort_column
    # when 'name', 'givengrade'
    #   # if Player.column_names.include?(sort_column)
    #   @problems = Problem.all.order("#{sort_column} #{sort_direction(direction: 'asc')}", :givengrade).paginate(page: params[:page],
    #                                                                                                             per_page: 20)
    # when 'status'
    #   @problems = Problem.all.to_a.sort_by { |p| p.status(current_user) }.paginate(page: params[:page], per_page: 20) if sort_direction == 'asc'
    #   @problems = Problem.all.to_a.sort_by { |p| p.status(current_user) }.reverse!.paginate(page: params[:page], per_page: 20) if sort_direction == 'desc'
    # end

    ajax_respond
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

  # clear_session defined in sessions_helper.rb
  def clear
    clear_session(:filter_grade, :filter_status)
    redirect_to problems_path
  end

  def summary
    @grade = Problem.distinct.pluck(:givengrade).sort!
  end

  def search
    clear_session(:filter_grade, :filter_status)
    # Without the ors (||) the sessions would get set to nil when redirecting to workouts other than through the
    # search form (e.g. by clicking workouts on the navbar) (as the params itmes are nil in these cases)
    session[:filter_grade] = params[:grade] || session[:filter_grade]
    # session[:filter_intensity] = params[:intensity] || session[:filter_intensity]
    session[:filter_status] = params[:status] || session[:filter_status]
    session[:advsearchshow] = params[:advsearchshow] || session[:advsearchshow]
    filters = [session[:filter_grade], session[:filter_status]]
    redirect_to problems_path
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
    %w[name givengrade setter status].include?(params[:sort]) ? params[:sort] : 'givengrade'
  end

  def ajax_respond
    respond_to do |format|
      format.html
      format.js
    end
  end

  def initialize_sort
    session[:sort_option] = params[:sort_option] || session[:sort_option] || 'givengrade_asc'
  end

  def handle_search
    @problems = Problem.all
    @problems = @problems.where(givengrade: session[:filter_grade]) if session[:filter_grade].present?
    @problems = @problems.select { |p| session[:filter_status].include?(p.status(current_user)) } if session[:filter_status].present?
    # hack to convert back to ActiveRecord for the order_by scopes of the index method, which will fail on an Array
    @problems = Problem.where(id: @problems.map(&:id)) if @problems.is_a?(Array)
  end

end

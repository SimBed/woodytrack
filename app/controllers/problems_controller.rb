class ProblemsController < ApplicationController
    before_action :set_problem, only: [:edit, :update, :destroy]
    before_action :admin_user,     only: [:new, :edit, :update, :destroy]
    
    helper_method :sort_column, :sort_direction
  
  def index
#    @problems = Problem.all.order(params[:sort], :name).paginate(page: params[:page],per_page: 10)
     @problems = Problem.all.order(sort_column + " " + sort_direction, :name).paginate(page: params[:page],per_page: 10)
  end
  
  def new
    @problem = Problem.new
  end

  # GET /problems/1/edit
  def edit
  end

  # POST /problems
  # POST /problems.json
  def create
    @problem = Problem.new(problem_params)

      if @problem.save
        redirect_to problems_path
        flash[:success] = "New problem added!"
      else
       render :new 
      end
  end
  
  def update
      if @problem.update(problem_params)
        redirect_to problems_path
        flash[:success] = "Problem updated"
      else
        render :edit
      end
  end
  
  def destroy
    @problem.destroy
    flash[:success] = "Problem deleted"
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
      params[:sort] || "name"
    end
    
    def sort_direction
      params[:direction] || "asc"
    end

end

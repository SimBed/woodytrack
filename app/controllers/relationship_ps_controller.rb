class RelationshipPsController < ApplicationController
  before_action :set_rel, only: [:edit, :update, :destroy]
  ##  before_action :admin_user,     only: [:new, :edit, :update, :destroy]
  
  helper_method :sort_column, :sort_direction

  def index
  #@problems = current_user.problems if logged_in?
  #@problems = current_user.problems.order(params[:sort], :name).paginate(page: params[:page],per_page: 10) if logged_in?
   @problems = current_user.problems.order(sort_column + " " + sort_direction, :name).paginate(page: params[:page],per_page: 10) if logged_in?
  end

  def new
    @relationship_ps = RelationshipP.new
  end

  def edit
  end


  def create
    #2 ways to trigger create method - 1) through web when following user, 2) when seeding
    if params[:commit] == 'Follow'
      @problem = Problem.find(params[:problem_id])
      current_user.probfollow(@problem)
      redirect_to problems_path
      flash[:success] = "New Problem Followed! Edit from My Problems."
    else
      @relationship_ps = RelationshipP.new(rel_params)
      if @relationship_ps.save
        redirect_to relationship_ps_path
        flash[:success] = "New Problem Followed! Edit from My Problems."
      else
       render :new 
      end
    end
  end
  
  def update
      if @relationship_ps.update(rel_params)
        redirect_to relationship_ps_path
        flash[:success] = "#{@probname} updated"
      else
        render :edit
      end
  end
  
  def destroy
    #@user = Relationship.find(params[:id]).followed
    #current_user.unfollow(@user)
    
    @relationship_ps.destroy
    flash[:success] = "#{@probname} no longer followed"
    redirect_to relationship_ps_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rel
      @relationship_ps = RelationshipP.find(params[:id])
      #so name can be included in flash messages
      @probname = Problem.find_by(id: @relationship_ps.problem_id).name
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rel_params
      #params.require(:relationship_p).permit(:suggestedgrade, :highpoint, :dohp, :firsttry, :rating)
       params.require(:relationship_p).permit(:user_id, :problem_id, :suggestedgrade, :highpoint, :dohp, :firsttry, :rating, :comment)
    end
    

    def sort_column
      #params[:sort] || "name"
      (RelationshipP.column_names+Problem.column_names).include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def sort_direction
      #params[:direction] || "asc"
      #additional code provides robust sanitisation of what goes into the order clause
      %w[asc desc].include?(params[:direction]) ? params[:direction]  : "asc"
    end
    
end
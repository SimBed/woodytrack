class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  helper_method :sort_column, :sort_direction

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      # equivalent to redirect_to user_url(@user) as Rail infers the user_url bit
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  def following
    @title = 'Following'
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def league_table
    # this approach makes @users an array whereas ActiveRecord preferred
    # @users = User.where(activated: true).select { |u| u.hasclimbed? }
     @users = User.where(activated: true).joins(:rel_user_problems).distinct
    case sort_column
    when 'name'
      @users = @users.order("#{sort_column} #{sort_direction(direction: 'asc')}").paginate(page: params[:page], per_page: 20)
    when 'tops'
      @users = @users.to_a.sort_by { |u| u.topouts }.paginate(page: params[:page], per_page: 20) if sort_direction == 'asc'
      @users = @users.to_a.sort_by { |u| u.topouts }.reverse!.paginate(page: params[:page], per_page: 20) if sort_direction == 'desc'
    end

    @grade = Problem.distinct.pluck(:givengrade).sort!

    ajax_respond
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def sort_column
    %w[name tops].include?(params[:sort]) ? params[:sort] : 'name'
  end

  def ajax_respond
    respond_to do |format|
      format.html
      format.js
    end
  end

end

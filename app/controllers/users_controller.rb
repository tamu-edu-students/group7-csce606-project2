class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authorize_user!, only: [:account]

  def index
    @users = User.all
    render "devise/index"
  end

  def show
    @tab = params[:tab] || "projects"
    @projects = @user.projects
    @joined_projects = @user.joined_projects
    @teaching_offers = @user.teaching_offers
    @joined_teaching_offers = @user.joined_teaching_offers
    @posts = @user.bulletin_posts
  end

  def account
    @user = current_user
    render "devise/account"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user!
    redirect_to root_path, alert: "You are not authorized to access this page." unless @user == current_user
  end
end

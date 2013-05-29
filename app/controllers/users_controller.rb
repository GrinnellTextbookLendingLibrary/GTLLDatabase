#borrowed liberally from hartl's ROR 3 tutorial
class UsersController < ApplicationController
  before_filter :authenticate_user
  before_filter :authenticate_manager, :except => [:show]
  before_filter :valid_user, :only => [:show]

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Add New User"
  end

  def create
    @temp_user = current_user
    @user = User.new(params[:user])
    if @user.save
      redirect_to @temp_user
    else
      @title = "Add New User"
      render 'new'
    end
  end

  def index
    @title = "All Users"
    @users = User.paginate(:per_page => 8, :page => params[:page])
  end

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def valid_user
    @user = User.find(params[:id])
    redirect_to(signin_path) unless current_user?(@user) || current_user.manager?
  end



end

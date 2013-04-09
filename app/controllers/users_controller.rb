#borrowed liberally from hartl's ROR 3 tutorial
class UsersController < ApplicationController
  before_filter :authenticate, :only => [:new, :create]


  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Add New User"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to @user
    else
      @title = "Add New User"
      render 'new'
    end
  end

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

end

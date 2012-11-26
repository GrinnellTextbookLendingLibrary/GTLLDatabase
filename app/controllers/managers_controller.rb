#borrowed liberally from hartl's ROR 3 tutorial
class ManagersController < ApplicationController
  before_filter :authenticate, :only => [:new, :create]


  def show
    @manager = Manager.find(params[:id])
    @title = @manager.name
  end

  def new
    @manager = Manager.new
    @title = "Add New Manager"
  end

  def create
    @manager = Manager.new(params[:manager])
    if @manager.save
      redirect_to @manager
    else
      @title = "Add New Manager"
      render 'new'
    end
  end

  def sign_in(manager)
    cookies.permanent.signed[:remember_token] = [manager.id, manager.salt]
    self.current_manager = manager
  end

end

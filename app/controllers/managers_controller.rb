class ManagersController < ApplicationController

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
  
end

class ManagersController < ApplicationController

  def show
    @manager = Manager.find(params[:id])
    @title = @manager.name
  end

  def new
    @title = "Add New Manager"
  end
  
end

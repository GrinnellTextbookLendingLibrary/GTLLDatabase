class ManagersController < ApplicationController

  def show
    @manager = Manager.find(params[:id])
  end

  def new
    @title = "Add New Manager"
  end
  
end

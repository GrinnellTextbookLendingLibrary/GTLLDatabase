class SessionsController < ApplicationController
  def new
    @title = "Manager Sign In"
  end

  def create
    manager = Manager.authenticate(params[:session][:email],
                             params[:session][:password])
    if manager.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Manager Sign In"
      render 'new'
    else
      sign_in manager
      redirect_to manager
    end
  end

  def destroy
  end
end

class PagesController < ApplicationController
  def home
    @title = "Home"
  end

  def index
    @title = "Index"
  end

end

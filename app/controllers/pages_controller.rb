class PagesController < ApplicationController
  def home
    @title = "Home"
  end

  def searchInfo
    @title = "Search Help"
  end

end

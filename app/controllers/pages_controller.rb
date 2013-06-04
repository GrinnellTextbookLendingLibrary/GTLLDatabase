class PagesController < ApplicationController

  before_filter :authenticate_user, :only => [:website_notes, :tech_notes]
  before_filter :authenticate_manager, :only => [:website_notes, :tech_notes]

  def home
    @title = "Home"
  end

  def searchInfo
    @title = "Search Help"
  end

  def checkoutProcedure
    @title = "Borrowing Books"
  end

  def website_notes
    @title = "Website Notes"
  end

  def tech_notes
    @title = "Tech Notes"
  end

end

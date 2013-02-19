require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.body.should have_selector("title", 
              :content => "Grinnell Textbook Lending Library | Home")
    end

    it "should have a search form" do
      get 'home'
      response.body.should have_selector("form[action='/books/search']")
    end
  end



end

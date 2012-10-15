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
      response.should have_selector("title", 
              :content => "Grinnell Textbook Lending Library | Home")
    end
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
    it "should have the right title" do
      get 'index'
      response.should have_selector("title", 
              :content => "Grinnell Textbook Lending Library | Index")
    end
  end


end

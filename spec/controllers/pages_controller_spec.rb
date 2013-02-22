require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    before(:each) do
      get 'home'
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.body.should have_selector("title", 
              :content => "Grinnell Textbook Lending Library | Home")
    end

    it "should have a search form" do
      response.body.should have_selector("form[action='/books/search']")
    end
  end

describe "GET 'index'" do
pending
end

pending "GET add book form, add manager form, manager page, book entry pages... do we need to test every one?"


end

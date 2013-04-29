require 'spec_helper'

describe "Pages (static content)" do

  describe "Home page" do
    it "should have the title Home" do
      visit '/'
      page.should have_selector('title', :text => "Grinnell Textbook Lending Library | Home")
    end
    
    it "should have the h1 Grinnell Textbook Lending Library" do
      visit '/'
      page.should have_selector('h1', :text => "Grinnell Textbook Lending Library")
    end
  end #Home page spec end

  describe "Index page" do
    it "should have the title Index of Books" do
      visit '/index'
      page.should have_selector('title', :text => "Grinnell Textbook Lending Library | Index of Books")    
    end
    
    it "should have the h1 Index of Books" do
      visit '/index'
      page.should have_selector('h1', :text => "Index of Books") 
    end
  end #Index page spec end

  describe "Search help page" do
    it "should have the title Search Help" do
      visit '/searchInfo'
      page.should have_selector('title', :text => "Grinnell Textbook Lending Library | Search Help")  
    end

    it "should have the h1 Search Information" do
      visit '/searchInfo'
      page.should have_selector('h1', :text => "Search Information")  
    end
  end #Search help page spec end

end #Pages (static content) spec end

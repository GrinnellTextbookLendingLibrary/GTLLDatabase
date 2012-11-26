require 'spec_helper'

describe "LayoutLinks" do

  it "should have a homepage at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
    it "should have an index page at '/index'" do
    get '/index'
    response.should have_selector('title', :content => "Index")
  end

describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Manager Sign In")
    end
  end

  describe "when signed in" do
    before(:each) do
     @manager = Factory(:manager)
      visit signin_path
      fill_in :email,    :with => "foobarclone@example.com"
      fill_in :password, :with => "foobar"
      click_button "Sign in"
    end

    it "should have a signout link" do      
 
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                    :content => "Sign out")
    end
  end
end

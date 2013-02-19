require 'spec_helper'

describe "LayoutLinks" do

  it "should have a homepage at '/'" do
    get '/'
    response.body.should have_selector('title', :content => "Home")
  end
    it "should have an index page at '/index'" do
    get '/index'
    response.body.should have_selector('title', :content => "Index")
  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
        page.should have_link("Manager Sign In", :href => signin_path)
    end
  end

  describe "when signed in" do
 #   before(:each) do
 #    @manager = Factory(:manager)
 #     visit signin_path
 #     fill_in :email,    :with => "foobarclone@example.com"
 #     fill_in :password, :with => "foobar"
 #     click_button "Sign in"      
 #     visit root_path
#    end

#    it "should have a signout link" do    
#      within ("head") do  
    #    page.should have_link('Sign out', :href => signout_path)
 #       page.should have_link('Index', :href => index_path)
#      end
#    end

#    let(:manager) { Factory(:manager) }
#    before do
#      visit signin_path
#      fill_in "Email",    :with => manager.email.upcase
#      fill_in "Password", :with => manager.password
#      click_button "Sign in"
#    end
#
#    it { should have_link('Sign out', :href => signout_path) }
  end
end

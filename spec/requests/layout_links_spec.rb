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

  it "should have a link to the procedure page" do
    pending
  end
  
  it "should have a procedure page at checkoutProcedure" do
    pending
  end

  it "should have a link to the page which describes search" do
    pending
  end

  it "should have a page which describes search at searchInfo" do
    pending
  end

  it "should have a link to the sample checkout form" do
    pending
  end

  it "should have a sample checkout form at sampleCheckoutForm" do
    pending
  end

  it "should have a link to the homepage" do
    pending
  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
        page.should have_link("Manager Sign In", :href => signin_path)
    end
  end

  describe "when signed in" do
    pending "should have signout link in header when signed in"
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

    it "should have an Add Book link" do
      pending
    end
    
    it "should have an Add Book page at books/new" do
      pending
    end

    it "should have a link to the manager's profile" do
      pending
    end

    it "should have a manager's profile page" do
      pending
    end

    it "should have a link to a Create New Manager form" do
      pending
    end
    
    it "should have a Create New Manager page" do
      pending
    end
  end
end

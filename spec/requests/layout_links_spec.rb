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
    get '/'
    response.body.should have_selector('a', :content => "procedure")
  end
 
  it "should have a procedure page at checkoutProcedure" do
    get '/checkoutProcedure'
    response.body.should have_selector('h1', :content => "Procedure for Borrowing Books")
  end

  it "should have a link to the page which describes search" do
    get '/'
    response.body.should have_selector('a', :content => "How do I search?")
  end

  it "should have a page which describes search at searchInfo" do
    get '/searchInfo'
    response.body.should have_selector('h1', :content => "Search Information")
  end

  it "should have a link to the sample checkout form" do
    get '/checkoutProcedure'
    response.body.should have_selector('a', :content => "Sample Checkout Form")
  end
  
  it "should have a sample checkout form at sampleCheckoutForm" do
    get '/sampleCheckoutForm'
    pending
  end

  it "should have a link to the homepage" do
    get '/'
    response.body.should have_selector('a img', :content => "Sample Checkout Form")
  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
        page.should have_link("User Sign In", :href => signin_path)
    end
  end

  describe "when signed in" do
    pending "should have signout link in header when signed in"
 #   before(:each) do
 #    @user = Factory(:user)
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

#    let(:user) { Factory(:user) }
#    before do
#      visit signin_path
#      fill_in "Email",    :with => user.email.upcase
#      fill_in "Password", :with => user.password
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

    it "should have a link to the user's profile" do
      pending
    end

    it "should have a user's profile page" do
      pending
    end

    it "should have a link to a Create New User form" do
      pending
    end
    
    it "should have a Create New User page" do
      pending
    end
  end
end

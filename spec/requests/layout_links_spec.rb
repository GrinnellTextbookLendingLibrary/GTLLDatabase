require 'spec_helper'

describe "LayoutLinks" do

  it "should have a homepage at '/'" do
    get '/'
    response.body.should have_selector('title', :text => "Home")
  end

  it "should have an index page at '/index'" do
    get '/index'
    response.body.should have_selector('title', :text => "Index")
  end

  it "should have a link to the procedure page" do
    get '/'
    response.body.should have_selector('a', :text => "procedure")
  end
 
  it "should have a procedure page at checkoutProcedure" do
    get '/checkoutProcedure'
    response.body.should have_selector('h1', :text => "Procedure for Borrowing Books")
  end

  it "should have a link to the page which describes search" do
    get '/'
    response.body.should have_selector('a', :text => "How do I search?")
  end

  it "should have a page which describes search at searchInfo" do
    get '/searchInfo'
    response.body.should have_selector('h1', :text => "Search Information")
  end

  it "should have a link to the sample checkout form" do
    get '/checkoutProcedure'
    response.body.should have_selector('a', :text => "Sample Checkout Form")
  end
  
  it "should have a sample checkout form at sampleCheckoutForm" do
    get '/sampleCheckoutForm'
    assert_response :success
  end

  it "should have a link to the homepage" do
    get '/'
    response.body.should have_link("Grinnell Textbook Lending Library", 
                                   :href => root_path)
  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      page.should have_link("User Sign In", :href => signin_path)
    end
    
    it "should not have a profile link" do
      visit root_path
      page.should_not have_content "Profile"
    end
  end
  
  describe "when signed in as a user" do
    before(:each) do
      @user = Factory(:user)
      
      visit root_path
      click_link "User Sign In"
      fill_in "Email",    :with => "foobarclone@example.com"
      fill_in "Password", :with => "foobar"
      click_button "Sign in"      
      visit root_path
      Book.create!(:name => "Math", :authors => "Math prof",
                   :edition => "1", :avail_copies => 13,
                   :total_num_copies => 200)
    end
    
    it "should have a link to home" do    
      within ("header") do  
        page.should have_link('Home', :href => root_path)
      end
    end

    it "should have a link to index" do    
      within ("header") do  
        page.should have_link('Index', :href => index_path)
      end
    end

    it "should have a signout link" do    
      within ("header") do  
        page.should have_link('Sign out', :href => signout_path)
      end
    end
 
    it "should have a profile link" do    
      within ("header") do  
        page.should have_content "Profile"
      end
    end   

    it "should not have an Add Book link" do
      within ("header") do  
        page.should_not have_link('Add Book', :href => new_book_path)
      end
    end

    describe "on the index page" do
      before(:each) do
        click_link "Index"
      end

      it "should not have a checkout link" do
        page.should_not have_content "Checkout"
      end
      
      it "should not have a checkin link" do
        page.should_not have_content 'Checkin'
      end
      
      it "should not have a entry link" do
        page.should_not have_content 'Entry'
      end
      
      it "should not have a delete link" do
        page.should_not have_content 'Delete'
      end
    end #Ends "on the index page"
  end #Ends "when signed in as a user"

  describe "when signed in as a manager" do
    before(:each) do
      @manager = Factory(:manager)
      visit root_path
      click_link "User Sign In"
      fill_in "Email",    :with => "foobarklone@example.com"
      fill_in "Password", :with => "foobar"
      click_button "Sign in"      
      visit root_path
      Book.create!(:name => "Math", :authors => "Math prof",
                   :edition => "1", :avail_copies => 13,
                   :total_num_copies => 200)
    end

    describe "the header" do
      it "should have an Add Book link" do
        page.should have_link('Add Book', :href => new_book_path)
      end
      
      it "should have an Add Book page" do
        click_link "Add Book"
        page.should have_content 'Add Book'
      end
      
      it "should have a link to the user's profile" do
        page.should have_content "Profile"
      end
      
      describe "manager's profile" do
        before(:each) do
          click_link "Profile"
        end

        it "should have a manager's profile page" do
          page.should have_content @manager.name
        end
      
        it "should have a link to a Create New User/Manager form" do
          page.should have_link 'Add New User/Manager', :href => signup_path
        end
      
        it "should have a Create New User/Manager page" do
          get '/signup'
          page.should have_content "Add New User/Manager"
        end
      end
    end

    describe "on the index page" do
      before(:each) do
        click_link "Index"
      end
      
      it "should have a checkout link" do
        page.should have_link("Checkout")
      end
     
      it "should have a checkin link" do
        page.should have_link("Checkin")
      end
      
      it "should have a entry link" do
        page.should have_link("Entry")
      end
      
      it "should have a delete link" do
        page.should have_link("Delete")
      end
    end
  end
end

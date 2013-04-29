require 'spec_helper'

describe "Users" do
  
  describe "who are managers" do
    
    before(:each) do
      @manager = Factory(:manager)
      visit root_path
      click_link "User Sign In"
      fill_in "Email",    :with => "foobarklone@example.com"
      fill_in "Password", :with => "foobar"
      click_button "Sign in"      
      visit root_path
    end
    
    it "can create new users" do
      click_link "Profile"
      click_link "Add New User/Manager"
      fill_in "Name", :with => "Sam"
      fill_in "Email", :with => "green_eggs_and_ham@samiam.com"
      fill_in "Password", :with => "password"
      fill_in "Confirmation", :with => "password"
      click_button "Add User"
      page.should have_content('Sam')
    end
    
  it "can create new managers" do
      click_link "Profile"
      click_link "Add New User/Manager"
      fill_in "Name", :with => "Sam"
      fill_in "Email", :with => "green_eggs_and_ham@samiam.com"
      fill_in "Password", :with => "password"
      fill_in "Confirmation", :with => "password"
      check("Manager")
      click_button "Add User"
      page.should have_content('Sam')
    end
  end

  describe "who are not managers" do
    before(:each) do
      @manager = Factory(:manager)
      visit root_path
      click_link "User Sign In"
      fill_in "Email",    :with => "foobarklone@example.com"
      fill_in "Password", :with => "foobar"
      click_button "Sign in"      
      visit root_path
    end
  
    it "cannot create new users" do
      pending
    end

   it "cannot create new managers" do
      pending
    end
  end

  describe "sign in and sign out" do
    describe "failure" do
      it "should not sign a user in and out" do
        pending
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        pending
      end
    end
  end #sign in/out spec end

end #User spec end

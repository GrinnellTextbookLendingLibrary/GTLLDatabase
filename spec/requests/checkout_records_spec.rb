require 'spec_helper'

describe "Checkout Records" do
  
  describe "valid checkout" do

    before(:each) do
      @manager = Factory(:manager)
      visit root_path
      click_link "User Sign In"
      fill_in "Email",    :with => "foobarklone@example.com"
      fill_in "Password", :with => "foobar"
      click_button "Sign in"      
      visit root_path
      @book = Factory(:book)
      click_link "Index"
      click_link "Checkout"
    end

    it "should have checkout page" do
      page.should have_content('Checkout')
    end

    it "should have book name" do
      page.should have_content(@book.name)
    end

    it "should display success message with correct user and book" do
      select @manager.name, :from => 'Select Borrower:'
      click_button 'Checkout'
      page.should have_content(["Book ", @book.name, " checked out to ", @manager.name].join )
    end
  end

  describe "invalid checkout" do
=begin
    before(:each) do
      @manager = Factory(:manager)
      visit root_path
      click_link "User Sign In"
      fill_in "Email",    :with => "foobarklone@example.com"
      fill_in "Password", :with => "foobar"
      click_button "Sign in"      
      visit root_path
      @book = Factory(:book)
      @book.avail_copies = 0
      @book.save
      click_link "Index"
      click_link "Checkout"
      select @manager.name, :from => 'Select Borrower:'
      click_button 'Checkout'
    end
=end
    it "should display an error message" do
      pending
    end

    it "should go back to index page" do
      pending
    end
  end
end

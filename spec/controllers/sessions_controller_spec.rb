#flagrantly c/p from Hartl ROR 3 Tutorial
require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Manager Sign In")
    end
  end

  describe "POST 'create'" do

    describe "invalid signin" do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Manager Sign In")
      end

      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    describe "with valid email and password" do

      before(:each) do
        @manager = Factory(:manager)
        @attr = { :email => @manager.email, :password => @manager.password }
      end

      it "should sign the manager in" do
        post :create, :session => @attr
        controller.current_manager.should == @manager
        controller.should be_signed_in
      end

      it "should redirect to the manager show page" do
        post :create, :session => @attr
        response.should redirect_to(manager_path(@manager))
      end
    end
  end
end

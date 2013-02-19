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
      response.body.should have_selector("title", :content => "Manager Sign In")
    end
  end

  describe "POST 'create'" do

    describe "invalid signin" do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
        post :create, :session => @attr
      end

      it "should re-render the new page" do
        response.should render_template('new')
      end

      it "should have the right title" do
        response.body.should have_selector("title", :content => "Manager Sign In")
      end

      it "should have a flash.now message" do
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    describe "with valid email and password" do

      before(:each) do
        @manager = Factory(:manager)
        @attr = { :email => @manager.email, :password => @manager.password }
        post :create, :session => @attr
      end

      it "should sign the manager in" do
        controller.current_manager.should == @manager
        controller.should be_signed_in
      end

      it "should redirect to the manager show page" do
        response.should redirect_to(manager_path(@manager))
      end
    end
  end

  describe "DELETE 'destroy'" do

    it "should sign a manager out" do
      test_sign_in(Factory(:manager))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end
  
end

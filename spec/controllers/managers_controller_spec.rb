require 'spec_helper'

#liberally c/p, influenced by Hartl's ROR 3 tutorial
describe ManagersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Add New Manager")
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @manager = Factory(:manager)
    end

    it "should be successful" do
      get :show, :id => @manager
      response.should be_success
    end

    it "should find the right manager" do
      get :show, :id => @manager
      assigns(:manager).should == @manager
    end

    it "should have the right title" do
      get :show, :id => @manager
      response.should have_selector("title", :content => @manager.name)
    end

    it "should include the manager's name" do
      get :show, :id => @manager
      response.should have_selector("h1", :content => @manager.name)
    end
  end
end

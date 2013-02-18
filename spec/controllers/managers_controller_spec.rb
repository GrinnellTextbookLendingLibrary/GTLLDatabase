require 'spec_helper'

#liberally c/p, influenced by Hartl's ROR 3 tutorial
describe ManagersController do
  render_views

  describe "authentication of creating new manager" do
    describe "for non-signed-in users" do

      it "should deny access to 'create'" do
        get :create, :manager => { :name => "New Manager", 
                                   :email => "manager@example.com",  
                                   :password => "foobar", 
                                   :password_confirmation => "foobar" }
        response.should redirect_to(signin_path)
      end
    end
  end
  
  describe "tests when signed in" do
    
    before(:each) do
      @manager = Factory(:manager)
      controller.sign_in(@manager)
    end
    
    describe "GET 'new'" do

      it "should be successful" do
        get 'new'
        response.should be_success
      end

      it "should have the right title" do
        get 'new'
        response.body.should have_selector('title', :content => "Add New Manager")
      end
    end
    
    describe "GET 'show'" do
      
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
        response.body.should have_selector("title", :content => @manager.name)
      end

      it "should include the manager's name" do
        get :show, :id => @manager
        response.body.should have_selector("h1", :content => @manager.name)
      end
    end
    
    describe "POST 'create'" do
      
      describe "failure" do

        before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
        end
        
        it "should not create a manager" do
          lambda do
            post :create, :manager => @attr
          end.should_not change(Manager, :count)
        end
        
        it "should have the right title" do
          post :create, :manager => @attr
          response.body.should have_selector("title", :content => "Add New Manager")
        end
        
        it "should render the 'new' page" do
          post :create, :manager => @attr
          response.should render_template('new')
        end
      end
      
      describe "success" do
        
        before(:each) do
        @attr = { :name => "New Manager", :email => "manager@example.com",
            :password => "foobar", :password_confirmation => "foobar" }
        end
        
        it "should create a manager" do
          lambda do
            post :create, :manager => @attr
          end.should change(Manager, :count).by(1)
        end
        
        it "should redirect to the manager show page" do
          post :create, :manager => @attr
          response.should redirect_to(manager_path(assigns(:manager)))
        end    
      end
    end
  end
end

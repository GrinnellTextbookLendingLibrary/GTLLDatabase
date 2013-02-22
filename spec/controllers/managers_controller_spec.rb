require 'spec_helper'

#liberally influenced by Hartl's ROR 3 tutorial
describe ManagersController do
  render_views

  describe "when not signed in" do
    it "should not be able to create new managers" do
      get :create, :manager => { :name => "New Manager", 
        :email => "manager@example.com",  
        :password => "foobar", 
        :password_confirmation => "foobar" }
      response.should redirect_to(signin_path)
    end
  end
  
  describe "when signed in" do
    
    before(:each) do
      @manager = Factory(:manager)
      controller.sign_in(@manager)
    end
    
    describe "GET 'new'" do
      before(:each) do
        get 'new'
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.body.should have_selector('title', :content => "Add New Manager")
      end
    end
    
    describe "GET 'show'" do
      before(:each) do
        get :show, :id => @manager
      end

      it "should be successful" do
        response.should be_success
      end
      
      it "should find the right manager" do
        assigns(:manager).should == @manager
      end
      
      it "should have the right title" do
        response.body.should have_selector("title", :content => @manager.name)
      end

      it "should include the manager's name" do
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

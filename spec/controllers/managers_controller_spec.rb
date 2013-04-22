require 'spec_helper'

#liberally influenced by Hartl's ROR 3 tutorial
describe UsersController do
  render_views

  describe "when not signed in" do
    it "should not be able to create new users" do
      get :create, :user => { :name => "New User", 
        :email => "user@example.com",  
        :password => "foobar", 
        :password_confirmation => "foobar" }
      response.should redirect_to(signin_path)
    end
  end
 
 
  describe "when signed in as a manager" do
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
        response.body.should have_selector('title', :content => "Add New User")
      end
    end # ends "GET new" block
    
    describe "GET 'show'" do
      before(:each) do
        get :show, :id => @manager
      end

      it "should be successful" do
        response.should be_success
      end
      
      it "should find the right user" do
        assigns(:user).should == @manager
      end
      
      it "should have the right title" do
        response.body.should have_selector("title", :content => @manager.name)
      end

      it "should include the manager's name" do
        response.body.should have_selector("h1", :content => @manager.name)
      end
    end # ends "GET show" block
    
    describe "POST 'create'" do
      
      describe "failure" do
        before(:each) do
          @attr = { :name => "", :email => "", :password => "",
                    :password_confirmation => "" }
        end
        
        it "should not create a user" do
          lambda do
            post :create, :user => @attr
          end.should_not change(User, :count)
        end
        
        it "should have the right title" do
          post :create, :user => @attr
          response.body.should have_selector("title", :content => "Add New User")
        end
        
        it "should render the 'new' page" do
          post :create, :user => @attr
          response.should render_template('new')
        end
      end # ends "failure" block
      
      describe "success" do        
        before(:each) do
          @attr = { :name => "New User", :email => "user@example.com",
                    :password => "foobar", :password_confirmation => "foobar" }
        end
        
        it "should create a user" do
          lambda do
            post :create, :user => @attr
          end.should change(User, :count).by(1)
        end
        
        it "should redirect to the user show page" do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end    
      end # ends "success" block
    end # ends "POST 'create'" block
  end # ends "when signed in as a manager"

  describe "when signed in as a user" do
    before (:each) do
      @user = Factory(:user)
      controller.sign_in(@user)
    end
    
    it "should not be successful in accessing the 'Create new user' page" do
      get 'new'
      response.should redirect_to(signin_path)
    end
    
    it "should not be able to create new users" do
      get :create, :user => { :name => "New User", 
        :email => "user@example.com",  
        :password => "foobar", 
        :password_confirmation => "foobar" }
      response.should redirect_to(signin_path)
    end
  end # ends "when signed in as a user" block
end

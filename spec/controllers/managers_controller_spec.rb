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
        response.body.should have_selector('title', :text => "Add New User")
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
        response.body.should have_selector("title", :text => @manager.name)
      end

      it "should include the manager's name" do
        response.body.should have_selector("h1", :text => @manager.name)
      end
    end # ends "GET show" block
    
    describe "GET 'index'" do
      it "should be able to visit index page" do
        get 'index'
        response.should be_success
      end

      it "should have the right title" do
        get 'index'
        response.body.should have_selector('title', :text => "All Users")
      end


      it "should list all users" do
        @attr1 = { :name => "User1", :email => "user1@example.com",
                    :password => "foobar", :password_confirmation => "foobar" }          
        @attr2 = { :name => "User2", :email => "user2@example.com",
                    :password => "foobar", :password_confirmation => "foobar" }          
        @attr3 = { :name => "User3", :email => "user3@example.com",
                    :password => "foobar", :password_confirmation => "foobar" }
        post :create, :user => @attr1
        post :create, :user => @attr2
        post :create, :user => @attr3
        get 'index'
        response.body.should have_content('User1')
        response.body.should have_content('User2')
        response.body.should have_content('User3')
        response.body.should have_content(@manager.name)
      end

    end


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
          response.body.should have_selector("title", :text => "Add New User")
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
        
        it "should redirect to the manager profile" do
          post :create, :user => @attr
          response.should redirect_to(@manager)
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

    it "should not be able to visit index page" do
      get 'index'
      response.should_not be_success
    end
  end # ends "when signed in as a user" block
end

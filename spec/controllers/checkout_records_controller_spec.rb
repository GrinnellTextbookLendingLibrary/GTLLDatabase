require 'spec_helper'

describe CheckoutRecordsController do
  render_views
  
  describe "new" do
    it "should deny access to users who are not signed-in managers" do
      @book = Factory(:book)
      @user = Factory(:user)
      post :new, :checkout_record => {:book_id => @book.id, 
        :user_id => @user.id }
      response.should redirect_to(signin_path)
    end

    it "should have the correct title" do
      pending 
#      get '/new_checkout_record'
#      response.body.should have_selector('title', :text => "Grinnell Textbook Lending Library | Checkout Book")
    end
  end #ends "new"

  describe "create" do

    describe "failure" do
      before(:each) do
        @book = Factory(:book)
        @book.save
      end

      it "should not create a checkout record when manager not signed in" do
        @user = Factory(:user)
        lambda do
        post :create, :checkout_record =>  {:book_id => @book.id, 
          :user_id => @user.id }
        end.should_not change(CheckoutRecord, :count)
      end
      
      it "should not create a checkout record with invalid user_id" do
        pending
      end
      
      it "should not create a checkout record with invalid book_id" do
        pending
      end
      
      describe "invalid checkout" do
        before(:each) do
          @user = Factory(:manager)
          controller.sign_in(@user)
          @book.avail_copies = 0
          @book.save
        end

        it "should not create a checkout record when checkout does not pass" do
          pending
          lambda do
            post :create, :checkout_record => {:book_id => @book.id, 
              :user_id => @user.id }
          end.should_not change(CheckoutRecord, :count)
        end
        
        it "should display failure message when book checkout does not pass" do
          pending
          post :create, :checkout_record => {:book_id => @book.id, 
            :user_id => @user.id }
          flash[:failure].should =~ /Cannot checkout book/i
        end

        it "should display failure message when user doesn't exist" do
          pending
          @book.avail_copies = 1
          @book.save
          post :create, :checkout_record => {:book_id => @book.id, 
            :user_id => -1 }
          flash[:failure].should =~ /Cannot checkout book- invalid user or book/i
        end
        
        it "should display failure message when book doesn't exist" do
          pending
        end
      end
    end

    describe "success" do
      
      before(:each) do
        @user = Factory(:manager)
        controller.sign_in(@user)
        @book = Factory(:book)
      end
      
      it "should create a checkout record if input if checkout does pass" do
        lambda do
          post :create, :checkout_record =>  {:book_id => @book.id, 
            :user_id => @user.id }
        end.should change(CheckoutRecord, :count).by(1)
      end
      
      it "should redirect to the index and print a flash message upon successful creation" do
        post :create, :checkout_record =>  {:book_id => @book.id, 
          :user_id => @user.id }
        response.should redirect_to(index_path)
      end

      it "should print a flash message upon successful creation" do
        post :create, :checkout_record =>  {:book_id => @book.id, 
          :user_id => @user.id }
        flash[:success].should =~ /checked out/
      end

    end #ends "success"
  end # create
 
  describe "show" do
  end #ends "show"

  describe "destroy" do
  end #ends "destroy"

end #end of spec

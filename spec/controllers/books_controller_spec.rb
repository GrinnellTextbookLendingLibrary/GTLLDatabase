#brazenly c/p from Hartl's ROR 3 Tutorial 
require 'spec_helper'

describe BooksController do
  render_views

  describe "index can always be accessed" do

    it "works when not signed in" do
      get 'index'
      response.should be_success
    end

    it "works when signed in" do
      @user = Factory(:user)
      controller.sign_in(@user)
      get 'index'
      response.should be_success
    end

    it "should have the right title" do
      get 'index'
      response.body.should have_selector("title", 
                                         :content => 
                                         "Grinnell Textbook Lending Library | Index")
    end
  end

  describe "when not signed in, records cannot be altered" do

    it "should deny access to 'create'" do
      post :create, :book => {:name => "2001: A Space Odyssey", 
        :authors => "Arthur C. Clarke", :edition => 1, :avail_copies => 2001, 
        :total_num_copies => 2010}
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'new'" do
      post :new, :book => {:name => "2001: A Space Odyssey", 
        :authors => "Arthur C. Clarke", :edition => 1, :avail_copies => 2001, 
        :total_num_copies => 2010}
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do      
      @book = Factory(:book)
      delete :destroy, :id => @book.id
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'checkin'" do      
      @book = Factory(:book)
      post:checkin, :id => @book
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'checkout'" do 
      @book = Factory(:book)
      post:checkout, :id => @book
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'update total num copies'" do   
      @book = Factory(:book)
      post:set_total_num_copies, :id => @book, :book => {:total_num_copies => 60}
      response.should redirect_to(signin_path)
    end

  end

  describe "when not signed in as a manager, records cannot be altered" do
    before(:each) do
      @user = Factory(:user)
      controller.sign_in(@user)
    end
    
    it "should deny access to 'create'" do
      post :create, :book => {:name => "2001: A Space Odyssey", 
        :authors => "Arthur C. Clarke", :edition => 1, :avail_copies => 2001, 
        :total_num_copies => 2010}
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'new'" do
      post :new, :book => {:name => "2001: A Space Odyssey", 
        :authors => "Arthur C. Clarke", :edition => 1, :avail_copies => 2001, 
        :total_num_copies => 2010}
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do      
      @book = Factory(:book)
      delete :destroy, :id => @book.id
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'checkin'" do      
      @book = Factory(:book)
      post:checkin, :id => @book
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'checkout'" do 
      @book = Factory(:book)
      post:checkout, :id => @book
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'update total num copies'" do   
      @book = Factory(:book)
      post:set_total_num_copies, :id => @book, :book => {:total_num_copies => 60}
      response.should redirect_to(signin_path)
    end

  end

  describe "when signed in as a manager, records can be created, destroyed, and updated" do

    before(:each) do
      @user = Factory(:user)
      @user.manager = true
      controller.sign_in(@user)
    end
    
    describe "GET 'new' book" do
      before(:each) do
        get :new
      end

      it "should be successful" do
        response.should be_success
      end
      
      it "should have the right title" do
        response.body.should have_selector("title", :content => "Add book")
      end
    end 
    
    describe "POST 'create' a new book record" do
    
      describe "invalid input should be rejected" do
      before(:each) do
          @attr = {:name => "", :authors => "", :edition => -1, 
            :avail_copies => nil, :total_num_copies => nil}
        end
      
        it "should not create a book" do
          lambda do
            post:create, :book => @attr
          end.should_not change(Book, :count)
        end

        it "should have a failure message" do
          post:create, :book => @attr
          page.has_content?("prohibited this book from being saved:")
        end
      end

      describe "valid input should create new record" do
        before(:each) do
          @attr = {:name => "The Once and Future King", 
            :authors => "T. H. White", :edition => "1", 
            :avail_copies => 1, :total_num_copies => 3}
        end
        
        it "should create a book" do
          lambda do
            post:create, :book => @attr
          end.should change(Book, :count).by(1)
        end
        
        it "should redirect to the Add Book page" do
          post:create, :book => @attr
          response.should redirect_to(new_book_path)
        end
        
        it "should have a success message" do
          post:create, :book => @attr
          flash[:success].should =~ /Book successfully added/
        end
      end
    end
    
    describe "DELETE 'destroy' a book" do

      before(:each) do
        @book = Factory(:book)
      end
      
      it "should destroy the book" do
        lambda do
          delete :destroy, :id => @book
        end.should change(Book, :count).by(-1)
      end
      
      it "should remain on index page" do
        delete :destroy, :id => @book
        response.should redirect_to(index_path)
      end
    end  
  end

  describe "Valid updates to number of copies" do

    before (:each) do
      @user = Factory(:user)
      @user.manager = true
      controller.sign_in(@user)
      @attr = {:name => "Examplary", :authors => "Scott", :edition => 1, 
        :avail_copies => 4, :total_num_copies => 7}
    end

    describe "No changes to number of copies should change the number of book records" do
      before (:each) do
        @book = Book.create!(@attr)
      end

      it "checkin should not change the total number of books" do
        lambda do
          post:checkin, :id => @book
        end.should change(Book, :count).by(0)
      end

      it "checkout should not change the total number of books" do
        lambda do
          post:checkout, :id => @book
        end.should change(Book, :count).by(0)
      end

      it "should not change the total number of books" do
        lambda do
          put:set_total_num_copies, :id => @book, :book => {:total_num_copies => 9}
        end.should change(Book, :count).by(0)
      end
    end
    
    describe "Valid checkin of a book" do
      before (:each) do
        @book = Book.create!(@attr)
        post:checkin, :id => @book
      end
      
      it "avalible copies should increase by 1" do
        @book.reload
        @book.avail_copies.should == 5
      end
      
      it "should not change any other attributes of the book" do
        @book.name.should == "Examplary"
        @book.authors.should == "Scott"
        @book.edition.should == 1
      end
      
      it "should display a useful flash message" do
        flash[:success].should =~ /one copy of:/i
        flash[:success].should =~ /checked in/i
      end 

      it "should remain on index page" do
        response.should redirect_to(index_path)
      end
    end

    describe "Valid checkout of a book" do
      before (:each) do
        @book = Book.create!(@attr)
        post:checkout, :id => @book
      end
      
      it "should check out a copy" do
        @book.reload
        @book.avail_copies.should == 3
      end
      
      it "should not change any other attributes of the book" do
        @book.name.should == "Examplary"
        @book.authors.should == "Scott"
        @book.edition.should == 1
      end
      
      it "should display a useful flash message" do
        flash[:success].should =~ /one copy of:/i
        flash[:success].should =~ /checked out/i
      end

      it "should remain on index page" do
        response.should redirect_to(index_path)
      end

    end
    
    describe "Valid updates to total number of copies" do
      before (:each) do
        @book = Book.create!(@attr)
        post:set_total_num_copies, :id => @book, :book => {:total_num_copies => 9}
      end

      it "should change total # of copies" do
        @book.reload
        @book.total_num_copies.should == 9
      end
      
      it "should not change any other attributes of the book" do
        @book.name.should == "Examplary"
        @book.authors.should == "Scott"
        @book.edition.should == 1
      end
      
      it "should display a useful flash message" do
        flash[:success].should =~ /total number of copies set to/i
      end

     it "should remain on entry page" do
        response.should redirect_to(:action => "show", :id => @book.id)
      end
    end
  end
  
  describe "Invalid updates to number of copies" do

    before (:each) do
      @user = Factory(:user)
      @user.manager = true
      controller.sign_in(@user)
      @attr = {:name => "Examplary", :authors => "Scott", :edition => 1, 
        :avail_copies => 7, :total_num_copies => 7}
      @book = Book.create!(@attr)
    end


    describe "Invalid checkin of a book" do
      before(:each) do
        post:checkin, :id => @book
      end

      it "should not change any attributes of the book" do
        @book.name.should == "Examplary"
        @book.authors.should == "Scott"
        @book.edition.should == 1
        @book.total_num_copies.should == 7
        @book.avail_copies.should == 7
      end

      it "should display a useful error message" do
        flash[:failure].should =~ /not successfully checked in/i
      end

     it "should remain on index page" do
        response.should redirect_to(index_path)
      end
    end

    describe "Invalid checkout of a book" do

      before(:each) do
        @book.avail_copies = 0
        @book.save
        post:checkout, :id => @book
      end
      
      it "should not change any attributes of the book" do
        @book.name.should == "Examplary"
        @book.authors.should == "Scott"
        @book.edition.should == 1
        @book.total_num_copies.should == 7
        @book.avail_copies.should == 0
      end

      it "should display a useful error message" do
        flash[:failure].should =~ /not successfully checked out/i
      end

      it "should remain on index page" do
        response.should redirect_to(index_path)
      end
    end

    describe "Invalid updates to total number of copies" do

      before(:each) do
        post:set_total_num_copies, :id => @book, :book => {:total_num_copies => 6}
      end
      
      it "should not change any attributes of the book" do
        @book.name.should == "Examplary"
        @book.authors.should == "Scott"
        @book.edition.should == 1
        @book.total_num_copies.should == 7
        @book.avail_copies.should == 7
      end

      it "should display a useful error message" do
        flash[:failure].should =~ /Attempted to set total number of copies to less than number of available copies/i
      end

      it "should remain on entry page" do
        response.should redirect_to(:action => "show", :id => @book.id)
      end
    end
  end
end

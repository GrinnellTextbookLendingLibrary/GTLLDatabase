#brazenly c/p from Hartl's ROR 3 Tutorial 
require 'spec_helper'

describe BooksController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create, :book => {:name => "2001: A Space Odyssey", 
        :authors => "Arthur C. Clarke", :edition => 1, :avail_copies => 2001, 
        :total_num_copies => 2010}
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do      
      @book = Factory(:book)
      delete :destroy, :id => @book.id
      response.should redirect_to(signin_path)
    end
  end

describe "signed in tests" do
    before(:each) do
      @manager = Factory(:manager)
      controller.sign_in(@manager)
    end
    
    describe "GET 'new'" do
      it "should be successful" do
        get :new
        response.should be_success
      end
      
      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "Add book")
      end
    end  
    
    describe "GET 'index'" do
      it "should be successful" do
        get 'index'
        response.should be_success
      end
      it "should have the right title" do
        get 'index'
        response.should have_selector("title", 
                                      :content => "Grinnell Textbook Lending Library | Index")
      end
    end
    
    describe "POST 'create'" do
    
      describe "failure" do
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
          response.should contain("prohibited this book from being saved:")
        end
      end

      describe "success" do
        before(:each) do
          @attr = {:name => "The Once and Future King", 
            :authors => "T. H. White", :edition => "1", :avail_copies => 1, :total_num_copies => 3}
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
    
    describe "DELETE 'destroy'" do

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

  describe "Updating number of copies" do
    before (:each) do
      @attr = {:name => "Examplary", :authors => "Scott", :edition => 1, 
        :avail_copies => 4, :total_num_copies => 7}
      @manager = Factory(:manager)
      controller.sign_in(@manager)
    end

    describe "Checkin a copy button" do

      it "should check in a copy" do
        @book = Book.create!(@attr)
        post:checkin, :id => @book
        @book.reload
        @book.avail_copies.should == 5
      end

      it "should not change any other attributes of the book" do
        @book = Book.create!(@attr)
        post:checkin, :id => @book
        @book.name.should == "Examplary"
        @book.authors.should == "Scott"
        @book.edition.should == 1
      end

      it "should not change the total number of books" do
        @book = Book.create!(@attr)
        lambda do
        post:checkin, :id => @book
        end.should change(Book, :count).by(0)
      end
      
      it "should display a useful flash message" do
        @book = Book.create!(@attr)
        post:checkin, :id => @book
        flash[:success].should =~ /One copy/
      end
    end 

    describe "Checkout a copy button" do

      it "should check out a copy" do
        @book = Book.create!(@attr)
        post:checkout, :id => @book
        @book.reload
        @book.avail_copies.should == 3
      end

      it "should not change any other attributes of the book" do
        @book = Book.create!(@attr)
        post:checkout, :id => @book
        @book.name.should == "Examplary"
        @book.authors.should == "Scott"
        @book.edition.should == 1
      end

      it "should not change the total number of books" do
        @book = Book.create!(@attr)
        lambda do
        post:checkout, :id => @book
        end.should change(Book, :count).by(0)
      end
      
      it "should display a useful flash message" do
        @book = Book.create!(@attr)
        post:checkout, :id => @book
        flash[:success].should =~ /One copy/
      end
    end 

    describe "Set total number of copies button" do

      it "should check in a copy" do
        @book = Book.create!(@attr)
        post:update, :id => @book, :total_num_copies => 9
        @book.reload
        @book.total_num_copies.should == 9
      end

      it "should not change any other attributes of the book" do
        @book = Book.create!(@attr)
        post:update, :id => @book, :total_num_copies => 9
        @book.name.should == "Examplary"
        @book.authors.should == "Scott"
        @book.edition.should == 1
      end

      it "should not change the total number of books" do
        @book = Book.create!(@attr)
        lambda do
        post:update, :id => @book, :total_num_copies => 9
        end.should change(Book, :count).by(0)
      end
      
      it "should display a useful flash message" do
        @book = Book.create!(@attr)
        puts @book.total_num_copies
        post:update
        puts @book.total_num_copies
        flash[:success].should =~ /One copy/
      end
    end
  end
end

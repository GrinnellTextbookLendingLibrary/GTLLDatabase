
require 'spec_helper'

describe Book do

  before (:each) do
    @attr = {:name => "Examplary", :authors => "Scott", 
      :edition => 1, :avail_copies => 1, :total_num_copies => 2}
  end

  it "should create a new instance given valid attributes" do
    Book.create!(@attr)
  end

  it "should require a name" do
    no_name_book = Book.new(@attr.merge(:name => ""))
    no_name_book.should_not be_valid
  end
  
  it "should require an author" do
    no_authors_book = Book.new(@attr.merge(:authors => ""))
    no_authors_book.should_not be_valid
  end

  it "should require an available number of copies" do
    no_avail_copies_book = Book.new(@attr.merge(:avail_copies => nil))
    no_avail_copies_book.should_not be_valid
  end

  it "should require a non-negative available number of copies" do
    neg_avail_copies_book = Book.new(@attr.merge(:avail_copies => -1))
    neg_avail_copies_book.should_not be_valid
  end

    it "should require a total number of copies" do
    no_total_copies_book = Book.new(@attr.merge(:total_num_copies => nil))
    no_total_copies_book.should_not be_valid
  end

  it "should require a non-negative total number of copies" do
    neg_total_copies_book = Book.new(@attr.merge(:total_num_copies => -1))
    neg_total_copies_book.should_not be_valid
  end

  it "should require that there are not more available copies than total copies" do
    too_many_copies_book = Book.new(@attr.merge(:avail_copies => 5000))
    too_many_copies_book.should_not be_valid
  end

  it "should not allow duplicate book" do
    #Same title, author, edition, and edition is present
    Book.create!(@attr)
    book_with_duplicate_attributes = Book.create(@attr)
    book_with_duplicate_attributes.should_not be_valid
  end

  #tests for presence of useful error message for duplicate book:
  it {should validate_uniqueness_of(:name).with_message(/duplicate entry/) }

  it {should validate_presence_of(:avail_copies).with_message(/must specify the number of copies/) }

  it "should not allow duplicate book without edition label" do
    #Same title, author, edition, with edition being null
    Book.create!(:name => "Lovely", :authors => "Splendid", :avail_copies => 8, :total_num_copies => 200)
    book_with_duplicate_attributes = Book.create(:name => "Lovely", 
                                                 :authors => "Splendid", :avail_copies => 8, :total_num_copies => 200)
    book_with_duplicate_attributes.should_not be_valid
  end

  it "should allow book with same title & authors but different edition" do
    Book.create!(:name => "Math", :authors => "Math prof", :edition => "1", :avail_copies => 2, :total_num_copies => 200)
    new_ed = Book.create(:name => "Math", :authors => "Math prof", 
                         :edition => "2", :avail_copies => 7, :total_num_copies => 200)
    new_ed.should be_valid
  end

  it "should allow book with same title & different authors" do
    Book.create!(:name => "Math", :authors => "Math prof", :edition => "1", :avail_copies => 13, :total_num_copies => 200)
    new_ed = Book.create(:name => "Math", :authors => "Math professor", 
                         :edition => "1", :avail_copies => 13, :total_num_copies => 200)
    new_ed.should be_valid
  end

  it "should allow book with same authors & different title" do
    Book.create!(:name => "Mathematics", :authors => "Math prof", :edition => "1", 
                 :avail_copies => 3, :total_num_copies => 200)
    new_ed = Book.create(:name => "Math", :authors => "Math prof", 
                         :edition => "1", :avail_copies => 3, :total_num_copies => 200)
    new_ed.should be_valid
  end
 


  describe "search" do
    before(:each) do
      @attr = {:name => "Art of War", :authors => "Sun Tzu", :edition => 1, :avail_copies => 21, :total_num_copies => 200}
      testbook = Book.create!(@attr)
    end

    it "should return the book on exact title match" do
      result = Book.search("Art of War", "")
      result.first.name.should match("Art of War")
    end 

    it "should return the book on partial title match" do
      book2 = Book.create!(:name => "Mart of Wal", :authors => "Zun Tsu", 
                   :edition => 20, :avail_copies => 1, :total_num_copies => 200)
      result = Book.search("rt of Wa", "")
      result.first.name.should match("Art of War")
      result.second.name.should match("Mart of Wal")
    end

    it "should not return more things than there are matches" do
      result = Book.search("rt of Wa", "")
      result.second.should be_nil
    end
    
    it "should return the book on exact author match" do
      result = Book.search("", "Sun Tzu")
      result.first.authors.should match("Sun Tzu")
    end

#Multiple author search too
    it "should return the book on matching one author" do
      manybook = Book.create!(:name => "How to SCIENCE", :authors => "Marie Curie, Bill Nye", :edition => 1, :avail_copies => 500, :total_num_copies => 600)
      result = Book.search("", "Bill")
      result.first.authors.should match("Marie Curie, Bill Nye")
    end

    it "should return the book on partial author match" do
      book2 = Book.create!(:name => "Mart of Wal", :authors => "Zun Tsu", 
                           :edition => 20, :avail_copies => 1, :total_num_copies => 600)
      result = Book.search("", "un T")
      result.first.authors.should match("Sun Tzu")
      result.second.authors.should match("Zun Tsu")
    end

    it "should not return books that match only author if title was also searched" do      
      result = Book.search("Not a Match", "Sun Tzu")
      result.first.should be_nil
    end

    it "should not return books that match only title if author was also searched" do   
      result = Book.search("rt of Wa", "Some Guy")
      result.first.should be_nil
    end

    it "should return book on exact author and title match" do
      book2 = Book.create!(:name => "Mart of Wal", :authors => "Zun Tsu", 
                           :edition => 20, :avail_copies => 1, :total_num_copies => 200)
      result = Book.search("Art of War", "Sun Tzu")
      result.first.name.should match("Art of War")
      result.first.authors.should match("Sun Tzu")
      result.second.should be_nil
    end

    it "should return book on partial author and title match" do
      book2 = Book.create!(:name => "Mart of Wal", :authors => "Zun Tsu", 
                           :edition => 20, :avail_copies => 1, :total_num_copies => 200)
      result = Book.search("rt of Wa", "un T")
      result.first.name.should match("Art of War")
      result.first.authors.should match("Sun Tzu")
      result.second.name.should match("Mart of Wal")
      result.second.authors.should match("Zun Tsu")
      result.third.should be_nil
    end

  end

  describe "Checkin" do
    describe "Checking in a copy" do
      before(:each) do
        @attr = {:name => "Mart of Wal", :authors => "Zun Tsu", 
          :edition => 20, :avail_copies => 1, :total_num_copies => 5}
      end
      it "should add a copy" do
        testbook = Book.create!(@attr)
        testbook.checkin
        testbook.avail_copies.should == 2
      end
      it "should not add more copies than there are total copies in the database" do
        testbook = Book.create!(@attr.merge(:avail_copies => 5))
        testbook.checkin.should be_false
      end
      it "should not change the total number of copies" do
        testbook = Book.create!(@attr)
        testbook.checkin
        testbook.total_num_copies.should == 5
      end
    end
  end

  describe "Checkout" do
    describe "Checking out a copy" do
      before(:each) do
        @attr = {:name => "Mart of Wal", :authors => "Zun Tsu", 
          :edition => 20, :avail_copies => 1, :total_num_copies => 5}
      end
      it "should remove a copy" do
        testbook = Book.create!(@attr)
        testbook.checkout
        testbook.avail_copies.should == 0
      end
      it "should not remove a copy if there are no copies in the database" do
        testbook = Book.create!(@attr.merge(:avail_copies => 0))
        testbook.checkout.should be_false
      end
      it "should not change the total number of copies" do
        testbook = Book.create!(@attr)
        testbook.checkout
        testbook.total_num_copies.should == 5
      end
    end
  end

  describe "Updating total copies: " do
      before(:each) do
        @attr = {:name => "Mart of Wal", :authors => "Zun Tsu", 
          :edition => 20, :avail_copies => 1, :total_num_copies => 5}
      end
    it "should update total copies" do
      book = Book.create!(@attr)
      book.set_total_num_copies(9)
      book.total_num_copies.should == 9
    end
    it "should update avail_copies if new total is larger than old total" do
      book = Book.create!(@attr)
      book.set_total_num_copies(9)
      book.avail_copies.should == 5
    end
    it "should not otherwise update available copies" do
      book = Book.create!(@attr)
      book.set_total_num_copies(4)
      book.avail_copies.should == 1
    end
    it "should not update if total is less than avail_copies" do
      book = Book.create!(@attr)
      book.set_total_num_copies(0).should be_false
    end
  end
end

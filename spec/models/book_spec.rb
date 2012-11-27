
require 'spec_helper'

describe Book do

  before (:each) do
    @attr = {:name => "Examplary", :authors => "Scott", :edition => 1, :num_copies => 1}
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

  it "should require a number of copies" do
    no_num_copies_book = Book.new(@attr.merge(:num_copies => nil))
    no_num_copies_book.should_not be_valid
  end

  it "should require a non-negative number of copies" do
    neg_num_copies_book = Book.new(@attr.merge(:num_copies => -1))
    neg_num_copies_book.should_not be_valid
  end

  it "should not allow duplicate book" do
    #Same title, author, edition, and edition is present
    Book.create!(@attr)
    book_with_duplicate_attributes = Book.create(@attr)
    book_with_duplicate_attributes.should_not be_valid
  end

  #tests for presence of useful error message for duplicate book:
  it {should validate_uniqueness_of(:name).with_message(/duplicate entry/) }

  it {should validate_presence_of(:num_copies).with_message(/must specify the number of copies/) }

  it "should not allow duplicate book without edition label" do
    #Same title, author, edition, with edition being null
    Book.create!(:name => "Lovely", :authors => "Splendid", :num_copies => 8)
    book_with_duplicate_attributes = Book.create(:name => "Lovely", 
                                                  :authors => "Splendid", :num_copies => 8)
    book_with_duplicate_attributes.should_not be_valid
  end

  it "should allow book with same title & authors but different edition" do
    Book.create!(:name => "Math", :authors => "Math prof", :edition => "1", :num_copies => 2)
    new_ed = Book.create(:name => "Math", :authors => "Math prof", 
                         :edition => "2", :num_copies => 7)
    new_ed.should be_valid
  end

  it "should allow book with same title & different authors" do
    Book.create!(:name => "Math", :authors => "Math prof", :edition => "1", :num_copies => 13)
    new_ed = Book.create(:name => "Math", :authors => "Math professor", 
                         :edition => "1", :num_copies => 13)
    new_ed.should be_valid
  end

  it "should allow book with same authors & different title" do
    Book.create!(:name => "Mathematics", :authors => "Math prof", :edition => "1", 
                 :num_copies => 3)
    new_ed = Book.create(:name => "Math", :authors => "Math prof", 
                         :edition => "1", :num_copies => 3)
    new_ed.should be_valid
  end
 
  describe "search" do
    before(:each) do
      @attr = {:name => "Art of War", :authors => "Sun Tzu", :edition => 1, :num_copies => 21}
    end

    it "should return the book on exact title match" do
      testbook = Book.create!(@attr)
      result = Book.search("Art of War", "")
      result.first.name.should match("Art of War")
    end 

    it "should return the book on partial title match" do
      testbook = Book.create!(@attr)
      book2 = Book.create!(:name => "Mart of Wal", :authors => "Zun Tsu", 
                   :edition => 20, :num_copies => 1)
      result = Book.search("rt of Wa", "")
      result.first.name.should match("Art of War")
      result.second.name.should match("Mart of Wal")
    end

    it "should not return more things than there are matches" do
      testbook = Book.create!(@attr)
      result = Book.search("rt of Wa", "")
      result.second.should be_nil
    end
    
    it "should return the book on exact author match" do
      testbook = Book.create!(@attr)
      result = Book.search("", "Sun Tzu")
      result.first.authors.should match("Sun Tzu")
    end

#Multiple author search too
    it "should return the book on matching one author" do
      manybook = Book.create!(:name => "How to SCIENCE", :authors => "Marie Curie, Bill Nye", :edition => 1, :num_copies => 500)
      result = Book.search("", "Bill")
      result.first.authors.should match("Marie Curie, Bill Nye")
    end

    it "should return the book on partial author match" do
      testbook = Book.create!(@attr)
      book2 = Book.create!(:name => "Mart of Wal", :authors => "Zun Tsu", 
                           :edition => 20, :num_copies => 1)
      result = Book.search("", "un T")
      result.first.authors.should match("Sun Tzu")
      result.second.authors.should match("Zun Tsu")
    end

    it "should not return books that match only author if title was also searched" do      
      testbook = Book.create!(@attr)
      result = Book.search("Not a Match", "Sun Tzu")
      result.first.should be_nil
    end

    it "should not return books that match only title if author was also searched" do   
      testbook = Book.create!(@attr)
      result = Book.search("rt of Wa", "Some Guy")
      result.first.should be_nil
    end

    it "should return book on exact author and title match" do
      testbook = Book.create!(@attr)
      book2 = Book.create!(:name => "Mart of Wal", :authors => "Zun Tsu", 
                           :edition => 20, :num_copies => 1)
      result = Book.search("Art of War", "Sun Tzu")
      result.first.name.should match("Art of War")
      result.first.authors.should match("Sun Tzu")
      result.second.should be_nil
    end

    it "should return book on partial author and title match" do
      testbook = Book.create!(@attr)
      book2 = Book.create!(:name => "Mart of Wal", :authors => "Zun Tsu", 
                           :edition => 20, :num_copies => 1)
      result = Book.search("rt of Wa", "un T")
      result.first.name.should match("Art of War")
      result.first.authors.should match("Sun Tzu")
      result.second.name.should match("Mart of Wal")
      result.second.authors.should match("Zun Tsu")
      result.third.should be_nil
    end

  end

  describe "Updating copies: " do
  end
end

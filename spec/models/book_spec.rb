require 'spec_helper'

describe Book do

  before (:each) do
    @attr = {:name => "Examplary", :authors => "Scott", :edition => 1}
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

  it "should not allow duplicate book" do
    #Same title, author, edition, and edition is present
    Book.create!(@attr)
    book_with_duplicate_attributes = Book.create(@attr)
    book_with_duplicate_attributes.should_not be_valid
  end

  it "should not allow duplicate book without edition label" do
    #Same title, author, edition, with edition being null
    Book.create!(:name => "Lovely", :authors => "Splendid")
    book_with_duplicate_attributes = Book.create(:name => "Lovely", 
                                                  :authors => "Splendid")
    book_with_duplicate_attributes.should_not be_valid
  end

  it "should allow book with same title & authors but different edition" do
    Book.create!(:name => "Math", :authors => "Math prof", :edition => "1")
    new_ed = Book.create(:name => "Math", :authors => "Math prof", 
                         :edition => "2")
    new_ed.should be_valid
  end

  it "should allow book with same title & different authors" do
    Book.create!(:name => "Math", :authors => "Math prof", :edition => "1")
    new_ed = Book.create(:name => "Math", :authors => "Math professor", 
                         :edition => "1")
    new_ed.should be_valid
  end

  it "should allow book with same authors & different title" do
    Book.create!(:name => "Mathematics", :authors => "Math prof", :edition => "1")
    new_ed = Book.create(:name => "Math", :authors => "Math prof", 
                         :edition => "1")
    new_ed.should be_valid
  end
 
  describe "search" do
    before(:each) do
      @attr = {:name => "Art of War", :authors => "Sun Tzu", :edition => 1}
    end

      it "should return the book on exact title match" do
      testbook = Book.create!(@attr)
      result = Book.search("Art of War")
      result.first.name.should match("Art of War")
    end 
    it "should return the book on partial title match" do
      testbook = Book.create!(@attr)
      book2 = Book.create!(:name => "Mart of Wal", :authors => "Zun Tsu", 
                   :edition => 20)
      result = Book.search("rt of Wa")
      result.first.name.should match("Art of War")
      result.second.name.should match("Mart of Wal")
    end

    it "should not return more things than there are matches" do
      testbook = Book.create!(@attr)
      result = Book.search("rt of Wa")
      result.second.should be_nil
    end
    
  end

end

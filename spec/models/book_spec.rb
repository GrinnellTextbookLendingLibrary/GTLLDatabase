require 'spec_helper'

describe Book do

  before (:each) do
    @attr = {:name => "Examplary", :authors => "Scott", :edition => 1}
  end

  it "should create a new instance given valid attributes" do
    Book.create! (@attr)
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
    book_with_duplicate_attributes = Book.new(@attr)
    book_with_duplicate_attributes.should_not be_valid
  end

  it "should not allow duplicate book without edition label" do
    #Same title, author, edition, with edition being null
    Book.create!(:name => "Lovely", :authors => "Splendid")
    book_with_duplicate_attributes = Book.new(:name => "Lovely", 
                                              :authors => "Splendid")
    book_with_duplicate_attributes.should_not be_valid
  end
 

end

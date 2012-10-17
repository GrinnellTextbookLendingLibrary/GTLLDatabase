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
  

end

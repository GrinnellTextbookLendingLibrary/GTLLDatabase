require 'spec_helper'

describe "Books" do

  describe "Creating a book" do
    describe "failure" do
      it "should not make a new book" do
        pending
      end
    end
    
    describe "success" do
      it "should make a new book" do
        pending
      end
    end
  end #Creating a book spec end

  describe "Finding a book" do
    before(:each) do
      Book.create!(:name => "Art of War", :authors => "Sun Tzu",
                   :edition => "10", :avail_copies => 10,
                   :total_num_copies => 20)
    end

    describe "failure" do
      it "should not find the book" do
        pending
      end
    end

    describe "success" do
      it "should find the book" do
        pending
      end
    end
  end #Finding a book spec end

  describe "Changing the number of copies" do
    describe "check-in" do
      describe "failure" do
        it "should not change the number of available copies" do
          pending
        end
      end
      
      describe "success" do
        it "should change the number of available copies" do
          pending
        end
      end
    end #check-in spec end

    describe "check-out" do
      describe "failure" do
        it "should not change the number of available copies" do
          pending
        end
      end
      
      describe "success" do
        it "should change the number of available copies" do
          pending
        end
      end
    end #check-out spec end
    
    describe "editing number of total copies" do
      describe "failure" do
        it "should not change the number of total copies" do
          pending
        end
      end
      
      describe "success" do
        it "should change the number of total copies" do
          pending
        end
      end
    end #editing number total copies spec end

    describe "deleting a book" do
      describe "failure:" do
        it "the book should still be in the database" do
          pending
        end
      end
      
      describe "success:" do
        it "the book should no longer be in the database" do
          pending
        end
      end
    end # deleting a book spec end

  end #Changing the number of copies spec end

end #Books spec end

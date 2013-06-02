require 'csv'

class BooksController < ApplicationController
  before_filter :authenticate_user, :except => [:index, :search]
  before_filter :authenticate_manager, :except => [:index, :search]

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
    @title = "Add Book"
  end

  def index
    @title = "Index of Books"
    @books = Book.paginate(:per_page => 8, :page => params[:page])
  end

  def create
    @book = Book.new(params[:book])
    @book.total_num_copies = @book.avail_copies
    if @book.save
      flash[:success] = ["Book successfully added: Name = ", @book.name, ", 
           Authors = ", @book.authors, ", Edition = ", @book.edition, 
                        ", Copies = ", @book.avail_copies].join
      redirect_to new_book_path
    else 
      @title = "Add Book"
      render 'new'
    end
  end

# 'records' method based off of code by Ryan Bates 
# retrieved from http://railscasts.com/episodes/362-exporting-csv-and-excel
# in May, 2013
  def records
    respond_to do |format|
      format.csv { send_data Book.to_csv }
      format.xls { send_data Book.to_csv(col_sep: "\t") }
    end
  end

  def destroy
    @book = Book.find(params[:id])
    if (@book.avail_copies == @book.total_num_copies)
      @book.destroy
      flash[:success] = ["Successfully deleted book: Name = ", @book.name, ", 
           Authors = ", @book.authors, ", Edition = ", @book.edition].join
    else
      flash[:failure] = "Cannot delete book; book has copies checked out."
    end
      redirect_to index_path
  end

#search based on https://we.riseup.net/rails/simple-search-tutorial
  def search
    @title = "Search"
    @books = Book.search(params[:title_search], 
                         params[:authors_search]).paginate(:per_page => 8, :page => params[:page])
    @temp_title = params[:title_search]
    @temp_authors = params[:authors_search]
  end

  def checkin
    @book = Book.find(params[:id])
    @book.checkin
    @book.save
    redirect_to index_path
  end

  def checkout
    @book = Book.find(params[:id])
    @book.checkout
    @book.save
    redirect_to index_path
  end

  def set_total_num_copies
    @book = Book.find(params[:id])
    @book.set_total_num_copies(params[:book][:total_num_copies].to_i)
    if @book.save
      flash[:success] = ["Total number of copies set to ", @book.total_num_copies].join
    else
      flash[:failure] = "Attempted to set total number of copies to less than number of available copies"
    end
    redirect_to book_path
  end
end

class BooksController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :destroy]

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
    @title = "Add book"
  end

  def index
    @title = "Index of books"
    @books = Book.paginate(:page => params[:page])    
  end

  def create
    @book = Book.new(params[:book])
    if @book.save
      flash[:success] = ["Book successfully added: Name = ", @book.name, ", 
           Authors = ", @book.authors, ", Edition = ", @book.edition, 
                        ", Copies = ", @book.num_copies].join
      redirect_to new_book_path
    else 
      @title = "Add book"
      render 'new'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    flash[:success] = ["Successfully deleted book: Name = ", @book.name, ", 
           Authors = ", @book.authors, ", Edition = ", @book.edition].join
    redirect_to index_path
  end

#search based on https://we.riseup.net/rails/simple-search-tutorial

  def search
    @books = Book.search(params[:title_search], params[:authors_search])
  end
end

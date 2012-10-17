class BooksController < ApplicationController
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
      flash[:success] = ["Book successfully added: Name = ", @book.name, ", Authors = ", @book.authors, ", Edition = ", @book.edition]
      redirect_to new_book_path
    else 
      @title = "Add book"
      flash[:failure] = "Invalid entry, book not added"
      redirect_to new_book_path
    end
  end
end

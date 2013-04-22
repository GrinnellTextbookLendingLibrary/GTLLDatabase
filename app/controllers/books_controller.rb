class BooksController < ApplicationController
  before_filter :authenticate_user, :only => [:new, :create, :destroy, 
                                              :checkin, :checkout, :update,
                                             :set_total_num_copies]
  before_filter :authenticate_manager, :only => [:new, :create, :destroy, 
                                                 :checkin, :checkout, :update, 
                                                 :set_total_num_copies]


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
    @book.total_num_copies = @book.avail_copies
    if @book.save
      flash[:success] = ["Book successfully added: Name = ", @book.name, ", 
           Authors = ", @book.authors, ", Edition = ", @book.edition, 
                        ", Copies = ", @book.avail_copies].join
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
    @books = Book.search(params[:title_search], 
                         params[:authors_search]).paginate(:page => params[:page])
    @temp_title = params[:title_search]
    @temp_authors = params[:authors_search]

    params[:title_search] = ""
    params[:authors_search] = ""
    
  end

  def checkin
    @book = Book.find(params[:id])
    @book.checkin
    if @book.save
      flash[:success] = ["One copy of: ", @book.name, " checked in"].join
    else
      flash[:failure] = [@book.name, " not successfully checked in; all copies already checked in"].join
    end
    redirect_to index_path
  end

  def checkout
    @book = Book.find(params[:id])
    @book.checkout
    if @book.save
      flash[:success] = ["One copy of: ", @book.name, " checked out"].join
    else
      flash[:failure] = [@book.name, " not successfully checked out; no more copies."].join
    end
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

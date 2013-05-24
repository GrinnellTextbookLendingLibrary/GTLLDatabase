class CheckoutRecordsController < ApplicationController
  before_filter :authenticate_user
  before_filter :authenticate_manager

  def new
    @checkout_record = CheckoutRecord.new
    @title = "Checkout Book"
  end
  
  def create
    @checkout_record = CheckoutRecord.new(params[:checkout_record])
    @book = @checkout_record.book
    @book.checkout
    ##### delete flash in book checkout method
    ##### delete/change redirect in book checkout method
    #### add flash failure
    if @book.save
      if @checkout_record.save
        flash[:success] = ["Book ", @checkout_record.book.name, 
                           " checked out to ", @checkout_record.user.name].join
        redirect_to index_path
      else
        flash[:failure] = "Cannot checkout book"        
        @title = "CheckoutBook"
        render 'new'
      end
    else
      flash[:failure] = "Cannot checkout book"
      @title = "CheckoutBook"
      render 'new'
    end
  end
  
  def show
  end

  def destroy
    #needs to find record with params
    @checkout_record = CheckoutRecord.where(:user_id => params[:user],
                                            :book_id => params[:book]).first
    @book = @checkout_record.book
    @book_name = @book.name

    #needs to call book checkin (i.e. increase avail_num_copies, etc.
    @book.checkin
    if @book.save
      #needs to destroy the record (but not records with same user/book)
      if @checkout_record.destroy
        flash[:success] = ["Book ", @book_name, " successfully checked in"].join
      else
        flash[:failure] = "Cannot checkin book" 
      end
    else
      flash[:failure] = "Cannot checkin book" 
    end
    redirect_to :back
  end
end

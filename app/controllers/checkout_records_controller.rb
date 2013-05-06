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
  end

end

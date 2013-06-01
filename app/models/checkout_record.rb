class CheckoutRecord < ActiveRecord::Base

  attr_accessible :book_id, :user_id

  belongs_to :book
  belongs_to :user

  validate :valid_book
  validate :valid_user

  def valid_book
    return false unless Book.find(self.book_id).avail_copies > 0
  end

  def valid_user
    return false if User.find(self.user_id).nil?
  end

end

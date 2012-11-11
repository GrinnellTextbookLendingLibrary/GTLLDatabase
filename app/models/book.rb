class Book < ActiveRecord::Base

  validates :name, :presence => true
  validates :authors, :presence => true 
  validates_uniqueness_of :name, :scope => [:authors, :edition],
  :message => ": This book already is in the database; I won't permit a duplicate entry!"
  #validates :num_copies, :presence => true, :greater_than_or_equal_to => 0
  validates_numericality_of :num_copies, :greater_than => -1
#Based heavily on example in https://we.riseup.net/rails/simple-search-tutorial

  def self.search(search)
    title = "%" + search + "%"
    find(:all, :conditions => ['name LIKE ?', title])
  end
end

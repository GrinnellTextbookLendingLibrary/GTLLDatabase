class Book < ActiveRecord::Base
  
  attr_accessible :name, :authors, :edition, :num_copies

  validates :name, :presence => true
  validates :authors, :presence => true 
  validates_uniqueness_of :name, :scope => [:authors, :edition],
  :message => ": This book already is in the database; I won't permit a duplicate entry!"
  #validates :num_copies, :presence => true, :greater_than_or_equal_to => 0
  validates_numericality_of :num_copies, :greater_than => -1,
  :message => "You must specify the number of copies"
#Based heavily on example in https://we.riseup.net/rails/simple-search-tutorial

  def self.search(title_search, authors_search)
    if title_search.nil? 
      title_search = ""
    end
    title = "%" + title_search + "%"
    if authors_search.nil?
      authors_search = ""
    end
    authors = "%" + authors_search + "%"
    find(:all, :conditions => ['name LIKE ? AND authors LIKE ?', title.downcase, authors.downcase])
  end

  def addCopy
   update_attribute("num_copies", num_copies + 1)
  end
end

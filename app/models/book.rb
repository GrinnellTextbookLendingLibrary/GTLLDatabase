class Book < ActiveRecord::Base
  
  attr_accessible :name, :authors, :edition, :avail_copies, :total_num_copies

  validates :name, :presence => true
  validates :authors, :presence => true 
  validates_uniqueness_of :name, :scope => [:authors, :edition],
  :message => ": This book already is in the database; I won't permit a duplicate entry!"

  validates_numericality_of :total_num_copies, :greater_than => 0

  validates_numericality_of :total_num_copies,
  :unless => Proc.new { |book| book.avail_copies.nil? },
  :greater_than_or_equal_to => :avail_copies

  #validates :avail_copies, :presence => true, :greater_than_or_equal_to => 0
  validates_numericality_of :avail_copies, :greater_than => -1,
  :message => "You must specify the number of copies"

  validates_numericality_of :avail_copies,
  :unless => Proc.new { |book| book.total_num_copies.nil? },
  :less_than_or_equal_to => :total_num_copies
  #Based heavily on example in https://we.riseup.net/rails/simple-search-tutorial

  default_scope :order => 'books.name ASC, books.authors ASC'

  def self.search(title_search, authors_search)
    if title_search.nil? 
      title_search = ""
    end
    title = "%" + title_search + "%"
    if authors_search.nil?
      authors_search = ""
    end
    conditions = ['LOWER(name) LIKE ?', title.downcase]
    authors = authors_search.downcase.split(/\s*[,;]?\s/)
    authors.each{ |author|
      conditions[0].concat(' AND LOWER(authors) LIKE ?')
      conditions << "%" + author.downcase + "%"
    }
    find(:all, :conditions => conditions)
  end

  def checkin
    update_attributes(:avail_copies => [avail_copies, 1].sum)
  end

  def checkout
   update_attributes(:avail_copies => [avail_copies, -1].sum)

  end

  def set_total_num_copies(new_total_copies)
    new_avail = avail_copies

    if (new_total_copies > total_num_copies)
      new_avail = avail_copies + (new_total_copies - total_num_copies)
    end

    update_attributes(:total_num_copies => new_total_copies, 
                      :avail_copies => new_avail)
  end
end

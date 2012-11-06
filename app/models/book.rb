class Book < ActiveRecord::Base
  
  validates :name, :presence => true
  validates :authors, :presence => true 
  validates :name, :uniqueness => { :scope => [:authors, :edition] }
  validates :authors, :uniqueness => { :scope => [:name, :edition] }

#Based heavily on example in https://we.riseup.net/rails/simple-search-tutorial

  def self.search(search)
    title = "%" + search + "%"
    find(:all, :conditions => ['name LIKE ?', title])
  end
end

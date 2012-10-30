class Book < ActiveRecord::Base
  
  validates :name, :presence => true
  validates :authors, :presence => true 
  validates :name, :uniqueness => { :scope => [:authors, :edition] }
  validates :authors, :uniqueness => { :scope => [:name, :edition] }

end

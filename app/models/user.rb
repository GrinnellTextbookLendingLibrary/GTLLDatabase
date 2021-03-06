require 'digest'
class User < ActiveRecord::Base

  has_many :checkout_records, :dependent => :destroy
  has_many :books, :through => :checkout_records

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :manager

  # A great deal of the following c/p or inspired from Hartl's ROR 3 Tutorial
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :email, :presence => true, :uniqueness => true
  validates :email, :format   => { :with => email_regex }
  validates :password, :presence => true, 
            :confirmation => true, 
            :length => { :within => 6..40 }

  before_save :encrypt_password

  default_scope :order => 'users.email ASC, users.name ASC'

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private

  def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
      secure_hash("#{salt}--#{string}")
  end

  def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
      Digest::SHA2.hexdigest(string)
  end
end

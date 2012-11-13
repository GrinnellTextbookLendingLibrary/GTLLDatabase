require 'digest'
class Manager < ActiveRecord::Base
  # A great deal of the following c/p or inspired from Hartl's ROR 3 Tutorial

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true,
            :format   => { :with => email_regex }
  validates :password, :presence => true, 
            :confirmation => true, 
            :length => { :within => 6..40 }

  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    manager = find_by_email(email)
    return nil  if manager.nil?
    return manager if manager.has_password?(submitted_password)
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

require 'spec_helper'

describe Manager do

pending "could refactor, but tests OK"

  describe "Creating a manager" do
    it {should validate_presence_of(:name) }
    it {should validate_presence_of(:email) }
    it {should validate_uniqueness_of(:name) }
    it {should validate_uniqueness_of(:email) }
  end

  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar" 
    }
  end

  #shamelessly c/p from Hartl's ROR 3 Tutorial
 it "should accept valid email addresses" do
    addresses = %w[manager@foo.com THE_MANAGER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_manager = Manager.new(@attr.merge(:email => address))
      valid_email_manager.should be_valid
    end
  end

  #also shamelessly c/p from Hartl's ROR 3 Tutorial
  it "should reject invalid email addresses" do
    addresses = %w[manager@foo,com manager_at_foo.org example.manager@foo.]
    addresses.each do |address|
      invalid_email_manager = Manager.new(@attr.merge(:email => address))
      invalid_email_manager.should_not be_valid
    end
  end

  #utterly shamelessly c/p from Hartl's ROR 3 Tutorial
  describe "password validations" do
    
    it "should require a password" do
      Manager.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      Manager.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      Manager.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      Manager.new(hash).should_not be_valid
    end
  end

  #further shamelessly c/p from Hartl's ROR 3 Tutorial
  describe "password encryption" do
    before(:each) do
      @manager = Manager.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @manager.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @manager.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @manager.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @manager.has_password?("invalid").should be_false
      end 
    end

    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_manager = Manager.authenticate(@attr[:email], "wrongpass")
        wrong_password_manager.should be_nil
      end

      it "should return nil for an email address with no manager" do
        nonexistent_manager = Manager.authenticate("bar@foo.com", @attr[:password])
        nonexistent_manager.should be_nil
      end

      it "should return the manager on email/password match" do
        matching_manager = Manager.authenticate(@attr[:email], @attr[:password])
        matching_manager.should == @manager
      end
    end
  end
end

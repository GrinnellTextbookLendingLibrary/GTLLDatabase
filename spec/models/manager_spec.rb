require 'spec_helper'

describe Manager do

  describe "Creating a manager" do
    it {should validate_presence_of(:name) }
    it {should validate_presence_of(:email) }
    it {should validate_uniqueness_of(:name) }
    it {should validate_uniqueness_of(:email) }
  end

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
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

end

require 'spec_helper'

describe "LayoutLinks" do
  it "should have a homepage at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
    it "should have an index page at '/index'" do
    get '/index'
    response.should have_selector('title', :content => "Index")
  end
end

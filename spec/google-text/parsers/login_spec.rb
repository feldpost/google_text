require 'spec_helper'

describe GoogleText::Parsers::Login do
  
  before(:each) do
    string = File.read("spec/data/login_url.html")
    @parser = GoogleText::Parsers::Login.new(string)
  end
  
  it "should extract an xsrf token" do
    @parser.xsrf_token.should eq "gw3tJxlUTos"
  end
  
end

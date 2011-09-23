require 'spec_helper'

describe GoogleText::Parsers::Inbox do
  
  before(:each) do
    string = File.read("spec/data/recent_messages.html")
    @parser = GoogleText::Parsers::Inbox.new(string)
  end
  
  it "should extract an xsrf token" do
    @parser.messages.should_not be_empty
  end
  
end

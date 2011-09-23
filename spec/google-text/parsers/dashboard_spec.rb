require 'spec_helper'

describe GoogleText::Parsers::Dashboard do
  
  before(:each) do
    string = File.read("spec/data/dashboard_url.html")
    @parser = GoogleText::Parsers::Dashboard.new(string)
  end
  
  it "should extract an session id" do
    @parser.session_id.should eq "WK7fnEZoPCizMP2Nx7UdqTdFnMA="
  end
  
end

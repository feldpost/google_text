require 'spec_helper'

describe GoogleText::Message do
  before(:all) do
    GoogleText.configure do |config|
      config.email        = 'baltimore'
      config.password     = 'crabcakes'
    end
  end
  
  let(:message) { GoogleText::Message.new :to => '(312) 123-4567', :text => "Hello World" }
  
  subject { message }
  
  it "should have stripped non-numeric characters from the phone number" do
    message.to.should == '3121234567'
  end
  
  it { should be_valid }
  
  context "send" do
    before(:each) do
      message.client.stub!(:login_page).and_return(File.read("spec/data/login_url.html"))
      message.client.stub!(:post_to_login).and_return(true)
      message.client.stub!(:dashboard_page).and_return(File.read("spec/data/dashboard_url.html"))
      message.client.stub!(:send_message).and_return(true)
    end
    it "should return a Message Object" do
      message.send.should be_a GoogleText::Message
    end
    
    it "should mark message as sent" do
      message.send
      message.should be_sent
    end
    
  end
  
end

require 'spec_helper'

describe GoogleText::Client do
  
  before(:all) do
    GoogleText.configure do |config|
      config.email        = 'baltimore'
      config.password     = 'crabcakes'
    end    
  end
    
    let(:client) { GoogleText::Client.new }
    
    it "should have established a GoogleText::Session obect" do
      client.session.should be_a(GoogleText::Session)
    end
    
    context "#get_xsrf_token" do
      before(:all) do
        client.stub!(:login_page).and_return(File.read("spec/data/login_url.html"))
      end
      
      it "should return a valid xsrf_token" do
        client.get_xsrf_token
        client.xsrf_token.should eq 'gw3tJxlUTos'      
      end
    end
    
    context "#login" do
      before(:each) do
        client.stub!(:login_page).and_return(File.read("spec/data/login_url.html"))
        client.stub!(:post_to_login).and_return(true)
        client.stub!(:dashboard_page).and_return(File.read("spec/data/dashboard_url.html"))
        client.login
      end
      
      it "should return a valid xsrf_token" do        
        client.xsrf_token.should_not be_nil
      end
      
      it "should advance the current page to GV dashboard which includes the account's phone number" do
        client.dashboard_page.should include('(312) 123-4567')
      end
      
      it "should retrieve the session id" do
        client.session_id.should == 'WK7fnEZoPCizMP2Nx7UdqTdFnMA='
      end
    end
    
    context "get_messages" do
      before(:each) do
        client.stub!(:login_page).and_return(File.read("spec/data/login_url.html"))
        client.stub!(:post_to_login).and_return(true)
        client.stub!(:dashboard_page).and_return(File.read("spec/data/dashboard_url.html"))
        client.stub!(:inbox_page).and_return(File.read("spec/data/recent_messages.html"))
        client.login
        @messages = client.get_messages
      end
      
      it "should return an non empty array" do
        @messages.should_not be_empty
      end
      
      context "message" do
        let(:message) {@messages.first}
        
        subject { message }
        
        it {should be_a GoogleText::Message}
        
        it "should have the correct from number" do
          message.from.should == "+13121234567"
        end
        
        it "should have the correct message text" do
          message.text.should == "Another message"
        end
        
        it "should be marked as unread" do
          message.should_not be_read
        end
        
      end
      
    end
    
end

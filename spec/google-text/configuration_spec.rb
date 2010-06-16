require 'spec_helper'

describe GoogleText::Configuration do
  before(:all) do
    GoogleText.configure do |config|
      config.email        = 'baltimore'
      config.password     = 'crabcakes'
    end
  end
  
  after(:all) do
    GoogleText.configuration.reset!
  end

  let(:configuration) { GoogleText.configuration }

  subject { configuration }

  it "should be set to supplied email address" do
    configuration.email.should == 'baltimore'
  end

  it "should be set to supplied password" do
    configuration.password.should == 'crabcakes'
  end

  it "should be set to the default dashboard_url when none is configured" do
    configuration.dashboard_url.should == "https://www.google.com/voice"
  end

  it "should overwrite default dashboard_url when supplied" do
    GoogleText.configure do |config|
      config.dashboard_url        = 'https://www.google.com/voice_portal'
    end
    configuration.dashboard_url.should == 'https://www.google.com/voice_portal'
  end
end

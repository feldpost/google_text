require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'fakeweb'

require File.expand_path(File.dirname(__FILE__) + "/../lib/google_text")

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
  config.mock_with :rspec
  
  config.before(:each) do
    FakeWeb.allow_net_connect = false
  end
  
end
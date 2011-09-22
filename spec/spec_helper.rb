require 'rubygems'
require 'bundler/setup'
require 'rspec'
require File.expand_path(File.dirname(__FILE__) + "/../lib/google_text")

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
  config.mock_with :rspec
end
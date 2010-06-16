# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift 'lib'
require 'google_text/version'

Gem::Specification.new do |s|
  s.name              = "google_text"
  s.version           = GoogleText::Version
  s.platform          = Gem::Platform::RUBY
  s.summary           = "GoogleText is a SMS client library for sending and receiving free SMS through Google Voice."
  s.description       = "GoogleText is a SMS client library for sending and receiving free SMS through Google Voice."
  
  s.homepage          = "http://github.com/feldpost/google_text"
  s.email             = "sebastian@feldpost.com"
  s.authors           = [ "Sebastian Friedrich" ]
  
  s.files             = %w( README.md Rakefile LICENSE )
  s.files            += Dir['[A-Z]*', 'lib/**/*.rb', 'spec/**/*.rb']
  
  s.require_path      = 'lib'
  
  s.test_files        = Dir['spec/**/*_spec.rb', 'features/**/*']
  
  s.add_dependency('curb', '~>0.7.6')
  s.add_dependency('nokogiri')
  s.add_dependency('json')
  
  s.add_development_dependency('rspec')
  
end




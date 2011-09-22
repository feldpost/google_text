# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'google_text/version'

Gem::Specification.new do |s|
  s.name              = "google_text"
  s.version           = GoogleText::Version
  s.platform          = Gem::Platform::RUBY
  s.summary           = "GoogleText is a SMS client library for sending and receiving free SMS through Google Voice."
  s.description       = "GoogleText is a SMS client library for sending and receiving free SMS through Google Voice. Alas, Google Voice does not yet have an API, so GoogleText uses Curl and Nokogiri to scrape and post using Google Voice web URLs."
  
  s.homepage          = "http://github.com/feldpost/google_text"
  s.email             = "sebastian@feldpost.com"
  s.authors           = [ "Sebastian Friedrich" ]
  
  s.rubyforge_project = "google_text"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "json"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "curb", '~>0.7.6'
  
  s.add_development_dependency('rspec')
  
end




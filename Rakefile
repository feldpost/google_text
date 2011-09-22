require 'rake/testtask'
require 'rake/rdoctask'
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

desc "Push a new version to Rubygems."
task :publish do
  require File.dirname(__FILE__) + '/lib/google_text/version'

  system "git tag v#{GoogleText::Version}"
  sh "gem build google_text.gemspec"
  sh "gem push google_text-#{GoogleText::Version}.gem"
  sh "git push origin master --tags"
  sh "git clean -fd"
end


desc "Install gem locally"
task :install do
  require File.dirname(__FILE__) + '/lib/google_text/version'
  sh "gem build google_text.gemspec"
  sh "sudo gem install ./google_text-#{GoogleText::Version}.gem"
end
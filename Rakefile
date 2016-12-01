ENV["RACK_ENV"] = "development" if ENV["RACK_ENV"].nil?
ENV["API_KEY"] = "api_key_123" if ENV["API_KEY"].nil?

require 'rack/test'
require 'rspec/core/rake_task'
require './spec/spec_helper'


# Loads the Gemfile libraries so it is not needed to use require all the time
Bundler.require(:default, ENV["RACK_ENV"].to_sym) 

# loads the required classes
Dir.glob("#{Dir.pwd}/models/*.rb") {|file| require file}


Mongoid.load!(ERB.new( File.expand_path('../config/mongoid.yml', __FILE__) ).result, ENV["RACK_ENV"].to_sym)

RSpec::Core::RakeTask.new
task :default => :spec

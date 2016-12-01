ENV['RACK_ENV'] = 'test'
ENV["API_KEY"] = "123_test" 
ENV["USERS_URL"] = "123_test" 


require 'rack/test'
require 'rspec'
require_relative '../app'


# Loads the Gemfile libraries so it is not needed to use require all the time
Bundler.require(:default, ENV["RACK_ENV"].to_sym) 

# loads the required classes
Dir.glob("#{Dir.pwd}/models/*.rb") {|file| require file}

Mongoid.load!(ERB.new( File.expand_path('../../config/mongoid.yml', __FILE__) ).result, ENV["RACK_ENV"].to_sym)
FactoryGirl.find_definitions

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include FactoryGirl::Syntax::Methods

  conf.before :each do
    DatabaseCleaner.orm = "mongoid"
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  conf.after do
    DatabaseCleaner.clean
  end  
end


def app
  App
end
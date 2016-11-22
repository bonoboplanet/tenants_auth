require './app'

ENV["RACK_ENV"] = "development" if ENV["RACK_ENV"].nil?
ENV["USERS_URL"] = "http://localhost:3002" if ENV["USERS_URL"].nil?
ENV["API_KEY"] = "api_key_123" if ENV["API_KEY"].nil?

# Loads the Gemfile libraries so it is not needed to use require all the time
Bundler.require(:default, ENV["RACK_ENV"].to_sym) 

Dir.glob("#{Dir.pwd}/models/*.rb") {|file| require file}

configure {
	enable :logging
  Mongoid.load!(ERB.new( File.expand_path('../config/mongoid.yml', __FILE__) ).result, ENV["RACK_ENV"].to_sym)
}

run App
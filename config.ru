require './app'

ENV["RACK_ENV"] = "development" if ENV["RACK_ENV"].nil?

run App
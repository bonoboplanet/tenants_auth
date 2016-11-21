require 'sinatra/base'

class App < Sinatra::Application

  before '*' do
    unless request.path == "/status_check" or ENV["RACK_ENV"] == 'development'
      halt 403  unless  params[:api_key] == ENV["API_KEY"]
    end
  end

  get '/status_check' do
    halt 200, "Server ok"
  end

end
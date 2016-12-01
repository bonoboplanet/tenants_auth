require 'sinatra'
require 'rest-client'

class App < Sinatra::Application
 configure { set :views, Proc.new { File.join(Dir.pwd, "views/users/") } }

  before '*' do
    @authentication_token = env['HTTP_AUTHORIZATION']
    unless request.path == "/status" or ENV["RACK_ENV"] == 'development'
      halt 403  unless  params[:api_key] == ENV["API_KEY"]
    end
  end

  get '/status' do
    halt 200, "Server ok"
  end

  # Signs in an existing user (starts the session)
  # Permissions : Everybody
  post '/signin' do
  	hsh = post_body
    halt 400, { errors: "username not provided"}.to_json if hsh[:username].blank?
    halt 400, { errors: "password not provided"}.to_json if hsh[:password].blank?
  	password = Digest::MD5.hexdigest(hsh[:password] << hsh[:username] ) 
  	user = User.find_by(username: hsh[:username], pwd: password)
  	halt 400, { errors: "user or password incorrect"}.to_json if user.blank?
    user.generate_authentication_token!
    user.save
    halt 201, ( jbuilder :show, locals: { user: user } )
  end

  # Logs out the current user (Finishes the session)
  # Permissions : Logged in user
  delete '/signout' do
    halt 403 if @authentication_token.blank?
    user = User.find_by(auth_token: @authentication_token)
    halt 404, { errors: "authentication failed"}.to_json if user.blank?
    user.auth_token = nil
    user.save
    halt 204, { message: "user logged out"}.to_json
  end

  # Signs up and logs in a new user  (starts the session)
  # Permissions : Everybody
  post '/signup' do
    hsh = post_body
    begin
       response = RestClient.post "#{ENV['USERS_URL']}?current_user_role=1&api_key=#{ENV['API_KEY']}", hsh.to_json, {content_type: :json, accept: :json}
       if response.code == 201
           user = JSON.parse(response.body)["user"].with_indifferent_access
           user = User.find(user["id"].to_s)
           user.generate_authentication_token!
           user.save
           halt 201, ( jbuilder :show, locals: { user: user } )
       else
          halt response.code, response.body
       end

    rescue RestClient::ExceptionWithResponse => e
      halt e.response.code , e.response.body
   end

  end

  # Given an authentication token returns the logged in user
  # Permissions : Logged in user
  get '/current_user' do
    halt 403, { errors: "Authorization header required in the request"}.to_json if @authentication_token.blank?
    user = User.find_by(auth_token: @authentication_token)
    halt 200, ( jbuilder :show, locals: { user: user } ) unless user.blank?
    halt 404,  { errors: "authentication failed"}.to_json
  end

private

  def post_body 
    request.body.rewind
    JSON.parse(request.body.read).with_indifferent_access
  end

end
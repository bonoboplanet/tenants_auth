require 'spec_helper'
require 'ostruct'

describe "App tests" do

  before(:each) do
    @user = create(:user, username: "user_test")
  end

  it "should retutn 200 when checking the status" do
    get '/status'
    expect(last_response).to be_ok
  end

	describe "POST /signin" do

		  it "should return 1 unread notification for the current user" do
		    post "/signin?api_key=123_test", { password: "123", username: @user.username }.to_json
		    expect(last_response.status).to eq 201
		  	session = JSON.parse(last_response.body)["session"]
		    expect(session["username"]).to eq @user.username
		 	expect(session["first_name"]).to eq @user.first_name
		 	expect(session["last_name"]).to eq @user.last_name
		 	expect(session["email"]).to eq @user.email
		 	expect(session["auth_token"]).not_to be nil
		  end

		  it "should return 400 if username not provided" do
		    post "/signin?api_key=123_test", { password: "123" }.to_json
		    expect(last_response.status).to eq 400
		  end

		  it "should return 400 if password not provided" do
			post "/signin?api_key=123_test", {  username: @user.username }.to_json
		    expect(last_response.status).to eq 400
		  end

 		 it "should return 400 if password and username don't match with any user" do
  		    post "/signin?api_key=123_test", { password: "incorrect_password", username: @user.username }.to_json
		    expect(last_response.status).to eq 400
		  end

		  it "should return 403 - Unauthorized access if api_key not provided" do
			post "/signin", { password: "123", username: @user.username }.to_json
		    expect(last_response.status).to eq 403
		  end

		  it "should return 403 - Unauthorized access if api_key doesn't match" do
			post "/signin?api_key=incorrect_key", { password: "123", username: @user.username }.to_json
		    expect(last_response.status).to eq 403
		  end
	end


	describe "DELETE /signout" do


		  before(:each) do
		    @logged_user = create(:logged_user, username: "logged_user")
		  end

		  it "should return 200 when search by notification id" do
  		    delete "/signout?api_key=123_test", nil, {'HTTP_AUTHORIZATION' => "#{@logged_user.auth_token}"}
		    expect(last_response.status).to eq 204
		    @logged_user.reload
		 	expect(@logged_user.auth_token).to eq nil
		  end

		  it "should return 404 if token doen't belong to any session" do
  		    delete "/signout?api_key=123_test", nil, {'HTTP_AUTHORIZATION' => "incorrect_token"}
		    expect(last_response.status).to eq 404
		  end

		  it "should return 403 - HTTP_AUTHORIZATION not provided" do
  		    delete "/signout?api_key=123_test", nil, {}
		    expect(last_response.status).to eq 403
		  end

		  it "should return 403 - Unauthorized access if api_key not provided" do
  		    delete "/signout", nil, {'HTTP_AUTHORIZATION' => "#{@logged_user.auth_token}"}
		    expect(last_response.status).to eq 403
		  end

		  it "should return 403 - Unauthorized access if api_key doesn't match" do
  		    delete "/signout?api_key=incorrect_key", nil, {'HTTP_AUTHORIZATION' => "#{@logged_user.auth_token}"}
		    expect(last_response.status).to eq 403
		  end
	end

	describe "POST /signup" do

			before(:each) do
				@password = "123"
				@new_user = FactoryGirl.attributes_for(:new_user).with_indifferent_access
			end

		  it "should return 201 and return the created user" do

		  	# http://ruby-doc.org/stdlib-1.9.3/libdoc/ostruct/rdoc/OpenStruct.html
			mock_response = OpenStruct.new
			mock_response.code =  201
			mock_response.body = { "user" => @new_user }
			mock_response.body["user"]["id"]= "123"
			mock_response.body = mock_response.body.to_json
			allow(RestClient).to receive(:post)  { mock_response  }
			allow(User).to receive(:find).with("123") {  create(:new_user)}


			total_users_before = User.all.size
		    post "/signup?api_key=123_test", { username: @new_user["username"], email: @new_user["email"], password: @password, password_confirmation: @password	}.to_json
		    expect(last_response.status).to be 201
			total_users_after = User.all.size	 
		    expect(total_users_before + 1 ).to eq total_users_after 				    
		    session = JSON.parse(last_response.body)["session"]
		   	expect(session["email"]).to eq @new_user["email"]
		    expect(session["username"]).to eq @new_user["username"]
		 	expect(session["auth_token"]).not_to be nil		    		    		    		    		    		    
		  end


		 it "should return 400 if any validation error when creating user" do

		 	# http://ruby-doc.org/stdlib-1.9.3/libdoc/ostruct/rdoc/OpenStruct.html
			mock_response = OpenStruct.new
			mock_response.code =  400
			mock_response.body = {"error" => "error"}.to_json
			allow(RestClient).to receive(:post)  { mock_response  }

		  	total_users_before = User.all.size
		    post "/signup?api_key=123_test", { email: @new_user["email"], password: @password, password_confirmation: @password	}.to_json
		    expect(last_response.status).to be 400   
			total_users_after = User.all.size	 
		    expect(total_users_before).to eq total_users_after 		
		  end

		  it "should return 403 - Unauthorized access if api_key not provided" do
		    post "/signup", { username: @new_user["username"], email: @new_user["email"], password: @password, password_confirmation: @password	}.to_json
		    expect(last_response.status).to eq 403
		  end

		  it "should return 403 - Unauthorized access if api_key doesn't match" do
		    post "/signup?api_key=incorrect_key", { username: @new_user["username"], email: @new_user["email"], password: @password, password_confirmation: @password	}.to_json
		    expect(last_response.status).to eq 403
		  end
		 
	end	


	describe "GET /current_user" do


		  before(:each) do
		    @logged_user = create(:logged_user, username: "logged_user")
		  end
		  
		  it "should return 200 when search by notification id" do
  		    get "/current_user?api_key=123_test", nil, {'HTTP_AUTHORIZATION' => "#{@logged_user.auth_token}"}
		    expect(last_response.status).to eq 200
		  	session = JSON.parse(last_response.body)["session"]
		    expect(session["username"]).to eq @logged_user.username
		 	expect(session["first_name"]).to eq @logged_user.first_name
		 	expect(session["last_name"]).to eq @logged_user.last_name
		 	expect(session["email"]).to eq @logged_user.email
		 	expect(session["auth_token"]).to eq @logged_user.auth_token
		  end

		  it "should return 404 if token doen't belong to any session" do
  		    get "/current_user?api_key=123_test", nil, {'HTTP_AUTHORIZATION' => "wrong_token"}
		    expect(last_response.status).to eq 404
		  end

		  it "should return 403 - HTTP_AUTHORIZATION not provided" do
  		    get "/current_user?api_key=123_test", nil, {}
		    expect(last_response.status).to eq 403
		  end

		  it "should return 403 - Unauthorized access if api_key not provided" do
  		    get "/current_user", nil, {'HTTP_AUTHORIZATION' => "#{@logged_user.auth_token}"}
		    expect(last_response.status).to eq 403
		  end

		  it "should return 403 - Unauthorized access if api_key doesn't match" do
  		    get "/current_user?api_key=incorrect_key", nil, {'HTTP_AUTHORIZATION' => "#{@logged_user.auth_token}"}
		    expect(last_response.status).to eq 403
		  end
	end


end
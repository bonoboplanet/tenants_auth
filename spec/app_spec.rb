require 'spec_helper'

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

	# 	  it "should return 0 unread notification for the current user doesn't have any unread notification" do
	# 	    get "/?current_user_id=random_user_id&api_key=123_test"
	# 	    expect(last_response).to be_ok
	# 	    notifications = JSON.parse(last_response.body)["notifications"]
	# 	    expect(notifications.size).to eq 0
	# 	  end

	# 	  it "should return 403 - Unauthorized access if api_key not provided" do
	# 	    get "/?current_user_id=#{@notification.user_id_to}"
	# 	    expect(last_response.status).to eq 403
	# 	  end

	# 	  it "should return 403 - Unauthorized access if api_key doesn't match" do
	# 	    get "/?current_user_id=#{@notification.user_id_to}&api_key=incorrest_api_key"
	# 	    expect(last_response.status).to eq 403
	# 	  end
	end


	# describe "GET /:id" do

	# 	  it "should return 200 when search by notification id" do
	# 	    get "/#{@notification.id.to_s}?current_user_id=#{@notification.user_id_to}&api_key=123_test"
	# 	    expect(last_response).to be_ok
	# 	    notification = JSON.parse(last_response.body)["notification"]
	# 	    expect(notification["type"]).to eq @notification.type
	# 	    expect(notification["user_id_to"]).to eq @notification.user_id_to
	# 	    expect(notification["user_id_from"]).to eq @notification.user_id_from            
	# 	    expect(notification["content"]).to eq @notification.content
	# 	 	expect(notification["status"]).to eq @notification.status
	# 	  end

	# 	  it "should return 404 if notification not found" do
	# 	    get "/incorrect_id?current_user_id=#{@notification.user_id_to}&api_key=123_test"
	# 	    expect(last_response.status).to eq 404
	# 	  end

	# 	  it "should return 403 if notification doesn't belong to current_user_id" do
	# 	    get "/#{@notification.id.to_s}?current_user_id=random_user_id&api_key=123_test"
	# 	    expect(last_response.status).to eq 403
	# 	  end		
	# end

	# describe "PUT /:id" do

	# 	  it "should return 200 and modify  a notification from unread to read" do
	# 	    put "/#{@notification.id.to_s}/read?current_user_id=#{@notification.user_id_to}&api_key=123_test"
	# 	    expect(last_response).to be_ok
	# 	    notification = JSON.parse(last_response.body)["notification"]
	# 	    expect(notification["type"]).to eq @notification.type
	# 	    expect(notification["user_id_to"]).to eq @notification.user_id_to
	# 	    expect(notification["user_id_from"]).to eq @notification.user_id_from            
	# 	    expect(notification["content"]).to eq @notification.content
	# 	 	expect(notification["status"]).to eq "read"
	# 	  end

	# 	  it "should return 404 if notification not found" do
	# 	    put "/incorrect_id/read?current_user_id=#{@notification.user_id_to}&api_key=123_test"
	# 	    expect(last_response.status).to eq 404
	# 	  end

	# 	  it "should return 403 if notification doesn't belong to current_user_id" do
	# 	    put "/#{@notification.id.to_s}/read?current_user_id=random_user_id&api_key=123_test"
	# 	    expect(last_response.status).to eq 403
	# 	  end		
	# end


end
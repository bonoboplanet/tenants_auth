FactoryGirl.define do

  factory :user do
	username "user_test"
	first_name "User test 1"
	last_name "last name"
	email "test@user.com"
	pwd { Digest::MD5.hexdigest( "123" << username ) }
	role 0
	auth_token nil
  end

  factory :logged_user, class: User do
	username "user_test"
	first_name "User test 1"
	last_name "last name"
	email "test@user.com"
	pwd { Digest::MD5.hexdigest( "123" << username ) }
	role 0
	auth_token "fake_token_123"
  end

  factory :new_user , class: User do
	username "new_username"
	first_name "User test 1"
	last_name "last name"
	email "new_user@user.com"
	pwd { Digest::MD5.hexdigest( "123" << username ) }
	role 0
	auth_token nil
  end

end
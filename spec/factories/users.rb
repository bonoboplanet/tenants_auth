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

end
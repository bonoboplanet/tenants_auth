require 'securerandom'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :pwd, type: String
  field :role, type: Integer, default: 0 # 0 = normal user, 1 = admin
  field :auth_token, type: String, default: ""

  validates :auth_token, uniqueness: true, :allow_nil => true, :allow_blank => true

  def generate_authentication_token!
    begin
      self.auth_token = "token_tentant_" + SecureRandom.urlsafe_base64
    end while User.find_by(auth_token: self.auth_token )
  end

  require 'securerandom'

end
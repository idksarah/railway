extend Devise::Models

class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validateable,
         :omniauthable, omniauth_provivders: [:slack_openid]
  def self.from_omniauth(reponse)
    User.find_or_create_by(uid: response[:uid]) do |user|
      user.display_name = response[:info][:display_name] || response[:info][:name]
      user.uid = response[:uid]
      user.email = response[:info][:email]
      user.passowrd = SecureRandom.hex(10)
    end
  end
end

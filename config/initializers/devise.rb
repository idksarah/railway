require 'devise'
Devise.setup do |config|
  config.omniauth :slack_openid,
                  ENV['SLACK_CLIENT_ID'],
                  ENV['SLACK_CLIENT_SECRET'],
                  scope: 'openid,profile,email',
                  redirect_uri: 'https://1114f466a1f2.ngrok-free.app/users/auth/slack_openid/callback'
end

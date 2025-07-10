Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack_openid, ENV['SLACK_CLIENT_ID'], ENV['SLACK_CLIENT_SECRET']
end

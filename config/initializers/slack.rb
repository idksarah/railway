# config/initializers/slack.rb
Slack.configure do |config|
  config.token = ENV['SLACK_BOT_TOKEN']
end

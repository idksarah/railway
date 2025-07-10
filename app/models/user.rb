class User < ApplicationRecord
  extend Devise::Models
  devise :database_authenticatable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:slack_openid]

  def self.from_omniauth(response)
    User.find_or_create_by(uid: response[:uid]) do |user|
      user.display_name = response[:info][:display_name] || response[:info][:name]
      user.uid = response[:uid]
      user.email = response[:info][:email]
      user.password = SecureRandom.hex(10)
    end
  end

  def self.exchange_slack_token(code, redirect_uri)
    response = Faraday.post('https://slack.com/api/oauth.v2.access',
                            {
                              client_id: ENV['SLACK_CLIENT_ID'],
                              client_secret: ENV['SLACK_CLIENT_SECRET'],
                              redirect_uri: redirect_uri,
                              code: code
                            })

    result = JSON.parse(response.body)

    unless result['ok']
      Rails.logger.error("Slack OAuth error: #{result['error']}")
      raise StandardError, "Failed to authenticate with Slack: #{result['error']}"
    end

    slack_id = result['authed_user']['id']
    user = User.find_by(slack_id: slack_id)
    if user.present?
      Rails.logger.tagged('UserCreation') do
        Rails.logger.info({
          event: 'existing_user_found',
          slack_id: slack_id,
          user_id: user.id,
          email: user.email
        }.to_json)
      end
      return user
    end

    create_from_slack(slack_id)
  end

  def self.create_from_slack(slack_id)
    user_info = fetch_slack_user_info(slack_id)

    Rails.logger.tagged('UserCreation') do
      Rails.logger.info({
        event: 'user_not_found',
        slack_id: slack_id,
        email: user_info.user.profile.email,
        password: SecureRandom.hex(10)
      }.to_json)
    end

    user = User.new(
      slack_id: slack_id,
      display_name: user_info.user.profile.display_name.presence || user_info.user.profile.real_name,
      email: user_info.user.profile.email,
      password: SecureRandom.hex(10)
    )

    user.save!
    user
  end

  def self.fetch_slack_user_info(slack_id)
    client = Slack::Web::Client.new(token: ENV['SLACK_BOT_TOKEN'])
    client.users_info(user: slack_id)
  end
end

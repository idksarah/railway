# require 'httparty'
# class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
#   # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
#   skip_before_action :verify_authenticity_token

#   def slack_openid
#     @access_token = request.env['omniauth.auth'].credentials.token
#     response = HTTParty.get(
#       'https://slack.com/api/users.profile.get?user=' + request.env['omniauth.auth'].uid.split('-')[1], headers: {
#         Authorization: 'Bearer ' + ENV['BOT_USER_OAUTH_TOKEN'], 'Content-Type': 'application/json'
#       }
#     )
#     @display_name = response.dig('profile', 'display_name').presence || response.dig('profile', 'real_name')

#     @user = User.from_omniauth(request.env['omniauth.auth'], @display_name)
#     if @user.persisted?
#       sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
#       set_flash_message(:notice, :success, kind: 'slack_openid') if is_navigational_format?
#     else
#       session['devise.slack_openid_data'] = {
#         provider: request.env['omniauth.auth'].provider,
#         display_name: @display_name
#       }
#       redirect_to root_path
#     end
#   end

#   def failure
#     logger.info(params[:error_description])
#     reason = params[:error_description]
#     redirect_to root_path
#     set_flash_message(:notice, :failure, kind: 'slack', reason: reason) if is_navigational_format?
#   end
# end

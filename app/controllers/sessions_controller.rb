class SessionsController < ApplicationController
  def new
    state = SecureRandom.hex(24)
    session[:state] = state
    params = {
      client_id: ENV['SLACK_CLIENT_ID'],
      redirect_uri: slack_callback_url,
      state: state,
      user_scope: 'identity.basic,identity.email,identity.team,identity.avatar'
    }
    redirect_to "https://slack.com/oauth/v2/authorize?#{params.to_query}", allow_other_host: true
  end

  def create
    if params[:state] != session[:state]
      Rails.logger.tagged('Authentication') do
        Rails.logger.error({
          event: 'csrf_validation_failed',
          expected_state: session[:state],
          received_state: params[:state]
        }.to_json)
      end
      session[:state] = nil
      redirect_to root_path, alert: 'AUTHENTICATION FAILED'
      return
    end

    begin
      user = User.exchange_slack_token(params[:code], slack_callback_url)
      session[:user_id] = user.id
      Rails.logger.tagged('Authentication') do
        Rails.logger.info({
          event: 'authentication_successful',
          user_id: user.id,
          slack_id: user.slack_id
        }.to_json)
      end

      redirect_to new_drawing_path, notice: 'SUCCESSFULLY SIGNED IN'
    rescue StandardError => e
      Rails.logger.tagged('Authentication') do
        Rails.logger.error({
          event: 'authentication_failed',
          error: e.message
        }.to_json)
      end # hhng
      redirect_to root_path, alert: e.message
    end
  end

  def failure
    Rails.logger.tagged('Authentication') do
      Rails.logger.error({
        event: 'authentication_failed',
        error: 'OAuth failure callback'
      }.to_json)
    end
    redirect_to root_path, alert: 'AUTHENTICATION FAILED'
  end
end

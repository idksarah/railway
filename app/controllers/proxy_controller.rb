require 'open-uri'

class ProxyController < ApplicationController
  def image
    url = params[:url]

    if url.blank? || URI.parse(url).host != 'hc-cdn.hel1.your-objectstorage.com'
      render plain: 'Forbidden', status: :forbidden
      return
    end

    image_data = URI.open(url)
    send_data image_data.read,
              type: image_data.content_type,
              disposition: 'inline'
  rescue StandardError => e
    logger.error "Proxy error: #{e.message}"
    render plain: 'Internal Server Error', status: :internal_server_error
  end
end

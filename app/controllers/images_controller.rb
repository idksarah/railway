class ImagesController < ApplicationController
  def proxy_image
    url = params[:url]

    return head :bad_request if url.blank?

    begin
      require 'open-uri'

      Rails.logger.info "Fetching: #{url}"

      image_data = URI.open(url, 'User-Agent' => 'Mozilla/5.0')
      content_type = image_data.content_type || 'image/png'

      send_data image_data.read,
                type: content_type,
                disposition: 'inline'
    rescue StandardError => e
      Rails.logger.error "Proxy error: #{e.class} - #{e.message}"
      head :internal_server_error
    end
  end
end

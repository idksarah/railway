# frozen_string_literal: true

class DrawingComponent < ViewComponent::Base
  include Rails.application.routes.url_helpers
  def initialize(num:)
    @drawing = Drawing.find(num)
    @artist = @drawing.artist
    @image_url = @drawing.image_url
    @number = @drawing.id
  end
end

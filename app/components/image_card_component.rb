# frozen_string_literal: true

class ImageCardComponent < ViewComponent::Base
  def initialize(artist:, image:)
    @artist = artist
    @image = image
  end
end

class Drawing < ApplicationRecord
  validates :artist, :image_url, presence: true
end

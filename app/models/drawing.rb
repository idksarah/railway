class Drawing < ApplicationRecord
  validates :artist, :image, presence: true
  has_one_attached :image
end

class MoviesContainer < ActiveRecord::Base
  belongs_to :channel
  belongs_to :admin

  has_many :linked_movies, -> { order('position asc') }, dependent: :destroy
  has_many :movies, through: :linked_movies

  accepts_nested_attributes_for :linked_movies, allow_destroy: true

  def cover_image_url
    movies.first&.cover_image_url
  end

  def second_cover_image_url
    movies.second&.cover_image_url
  end

  def cover_images_urls
    movies.map(&:cover_image_url)
  end
end

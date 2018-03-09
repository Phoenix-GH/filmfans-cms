class CollectionsContainer < ActiveRecord::Base
  has_many :linked_collections, dependent: :destroy
  has_many :collections, through: :linked_collections

  belongs_to :admin

  accepts_nested_attributes_for :linked_collections, allow_destroy: true

  def cover_image_url
    collections.first&.cover_image_url
  end

  def second_cover_image_url
    collections.second&.cover_image_url
  end

  def cover_images_urls
    collections.map(&:cover_image_url)
  end

end

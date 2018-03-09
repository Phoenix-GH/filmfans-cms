class ManualPostContainer < ActiveRecord::Base
  has_many :linked_manual_posts, dependent: :destroy
  has_many :manual_posts, through: :linked_manual_posts

  accepts_nested_attributes_for :linked_manual_posts, allow_destroy: true

  def cover_image_url
    manual_posts.first&.custom_url
  end

  def second_cover_image_url
    manual_posts.second&.custom_url
  end
end
class TvShow < ActiveRecord::Base
  belongs_to :channel
  has_many :tv_show_seasons, dependent: :destroy
  has_many :seasons, foreign_key: "tv_show_id", class_name: "TvShowSeason"
  has_many :episodes, through: :tv_show_seasons
  has_many :links, dependent: :destroy, as: :target

  has_one :cover_image, class_name:  'TvShowCoverImage', dependent: :destroy
  has_one :background_image, class_name:  'TvShowBackgroundImage', dependent: :destroy
  accepts_nested_attributes_for :cover_image
  accepts_nested_attributes_for :background_image

  def cropper_data
    {
      background: background_image&.cropper_data,
      cover: cover_image&.cropper_data,
      update_url: "/panel/channels/#{channel_id}/tv_shows/#{id}/update_images",
      cropper_type: 'tv-show',
      id: "#{self.class.name}_#{id}"
    }
  end

  def cover_image_url
    cover_image&.custom_url
  end
end

class Magazine < ActiveRecord::Base
  belongs_to :channel
  has_many :volumes, dependent: :destroy
  has_many :issues, -> { order('publication_date desc') }, through: :volumes
  has_many :links, dependent: :destroy, as: :target

  has_one :cover_image, class_name:  'MagazineCoverImage', dependent: :destroy
  has_one :background_image, class_name:  'MagazineBackgroundImage', dependent: :destroy
  accepts_nested_attributes_for :cover_image
  accepts_nested_attributes_for :background_image

  def cropper_data
    {
      background: background_image&.cropper_data,
      cover: cover_image&.cropper_data,
      update_url: "/panel/channels/#{channel_id}/magazines/#{id}/update_images",
      cropper_type: 'magazine',
      id: "#{self.class.name}_#{id}"
    }
  end

  def cover_image_url
    cover_image&.custom_url
  end
end

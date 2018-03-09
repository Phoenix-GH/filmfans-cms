class Event < ActiveRecord::Base
  has_many :event_contents, dependent: :destroy
  has_many :linked_events, dependent: :destroy

  belongs_to :admin

  has_one :cover_image, class_name:  'EventCoverImage', dependent: :destroy
  has_one :background_image, class_name:  'EventBackgroundImage', dependent: :destroy
  accepts_nested_attributes_for :cover_image
  accepts_nested_attributes_for :background_image


  def cover_image_url
    cover_image&.custom_url
  end

  def cropper_data
    {
      background: background_image.cropper_data,
      cover: cover_image.cropper_data,
      update_url: "/panel/events/#{id}/update_images",
      cropper_type: 'event',
      id: "#{self.class.name}_#{id}"
    }
  end
end

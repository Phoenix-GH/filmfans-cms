class EventCoverImage < ActiveRecord::Base
  belongs_to :event, inverse_of: :cover_image

  mount_uploader :file, EventCoverImageUploader

  serialize :specification, JSON

  def custom_url
    return '' unless file.present?
    if file.custom.present?
      file.custom.url
    else
      file_url
    end
  end

  def cropper_data
    {
        original_picture_url: file_url,
        proportions: proportions,
        x: specification['crop_x'],
        y: specification['crop_y'],
        width: specification['width'],
        height: specification['height'],
        zoom: specification['zoom'],
        cropBoxX: specification['cropBox_x'],
        cropBoxY: specification['cropBox_y'],
        cropBoxHeight: specification['cropBox_height'],
        cropBoxWidth: specification['cropBox_width'],
    }
  end

  private
  def proportions
    '11x5'
  end
end

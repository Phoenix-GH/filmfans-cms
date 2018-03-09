class MediaOwnerBackgroundImage < ActiveRecord::Base
  belongs_to :media_owner, inverse_of: :background_image

  mount_uploader :file, MediaOwnerBackgroundImageUploader

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
      id: "#{self.class.name}_#{id}",
      update_url: "/panel/media_owner_background_images/#{id}",
      proportions: proportions,
      x: specification['crop_x'],
      y: specification['crop_y'],
      width: specification['width'],
      height: specification['height'],
      cropper_type: cropper_type,
      zoom: specification['zoom'],
      cropBoxX: specification['cropBox_x'],
      cropBoxY: specification['cropBox_y'],
      cropBoxHeight: specification['cropBox_height'],
      cropBoxWidth: specification['cropBox_width'],
    }
  end

  private
  def proportions
    '3x2'
  end

  def cropper_type
    'background'
  end
end

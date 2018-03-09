class MediaOwnerPicture < ActiveRecord::Base
  belongs_to :media_owner, inverse_of: :picture

  mount_uploader :file, MediaOwnerPictureUploader

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
      update_url: "/panel/media_owner_pictures/#{id}",
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
    '1x1'
  end

  def cropper_type
    'avatar'
  end
end

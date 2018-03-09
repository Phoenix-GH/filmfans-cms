module BaseCropableImageRecord

  def custom_url
    return '' unless mounted_image_attribute.present?
    if mounted_image_attribute.custom.present?
      mounted_image_attribute.custom.url
    else
      full_image_file_url
    end
  end

  def cropper_data
    {
        original_picture_url: full_image_file_url,
        id: "#{self.class.name}_#{id}",
        update_url: update_url,
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

  def update_url
    "/panel/#{self.class.to_s.underscore}s/#{id}"
  end

  # this method is called in CropableImageUploader
  def image_file_changed?
    raise 'please override image_file_changed?'
  end

  def full_image_file_url
    raise 'please override full_image_file_url'
  end

  protected

  def mounted_image_attribute
    raise 'please override mounted_image_attribute'
  end

  def proportions
    '1x1'
  end

  def cropper_type
    raise 'Please supply croper_type in subclass'
  end
end
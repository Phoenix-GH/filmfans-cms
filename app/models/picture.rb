# THIS CLASS NEEDS TO BE DELETED AFTER CreateMediaOwnerPictures & CreateMediaOwnerBackgroundImages migrations are run.

class Picture < ActiveRecord::Base
  belongs_to :pictureable, polymorphic: true

  mount_uploader :file, CustomizablePictureUploader

  serialize :specification, JSON

  before_update :reset_specifications, if: :file_changed?

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
      id: id,
      update_url: "/panel/pictures/#{id}",
      proportions: proportions,
      x: specification['crop_x'],
      y: specification['crop_y'],
      width: specification['width'],
      height: specification['height'],
      cropper_type: cropper_type
    }
  end

  private
  def proportions
    case picture_type
      when 'MediaOwnerPicture' then '1x1'
      when 'MediaOwnerBackgroundImage' then '3x2'
    end
  end

  def cropper_type
    case picture_type
      when 'MediaOwnerPicture' then 'avatar'
      when 'MediaOwnerBackgroundImage' then 'background'
    end
  end

  def reset_specifications
    update_column(:specification, {})
  end

end

class IssueCoverImage < ActiveRecord::Base
  belongs_to :issue, inverse_of: :cover_image

  mount_uploader :file, IssueCoverImageUploader

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
        update_url: "/panel/issue_cover_images/#{id}",
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
    '1.33x1.62'
  end

  def cropper_type
    'grid'
  end
end

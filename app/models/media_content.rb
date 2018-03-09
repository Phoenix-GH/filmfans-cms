class MediaContent < ActiveRecord::Base
  belongs_to :membership, polymorphic: true

  mount_uploader :cover_image, PictureUploader
  mount_uploader :file, FileUploader

  serialize :specification, JSON

  def mp4_version_file
    file_type.match('video/mp4') ? file : file.mp4
  end

  def image?
    file_type&.match('image/')
  end

  def video?
    file_type&.match('video/')
  end

  def combo_container_image_url
    if cover_image.present?
      cover_image&.combo_container_size.url.to_s
    else
      ''
    end
  end

  def media_container_image_url
    if cover_image.present?
      cover_image&.media_container_size.url.to_s
    else
      ''
    end
  end

  def large_image_url
    if cover_image.present?
      cover_image.url.to_s
    else
      ''
    end
  end

  def file_thumb_url
    if video?
      file&.video_thumb.url
    elsif image?
      file&.thumb.url
    end
  end
end

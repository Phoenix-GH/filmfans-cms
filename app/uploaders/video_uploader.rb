class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::Video
  include CarrierWave::Video::Thumbnailer

  process :save_file_specification

  version :video_thumb do
    process thumbnail: [
      {
        format: 'png',
        size: 1280
      }
    ]
    process :set_content_type_jpeg

    def full_filename for_file
      png_name for_file, version_name
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def full_url
    url
    # Rails.application.secrets.domain_name + url
  end

  def full_video_thumb_url
    video_thumb.url
    # Rails.application.secrets.domain_name + video_thumb.url
  end

  private
  def extension_white_list
    %w(mov avi mp4 mkv wmv mpg vob)
  end

  def save_file_specification
    return unless model && file

    Uploaders::SaveVideoSpecificationService.new(model, file).call
  end

  def png_name for_file, version_name
    "#{version_name}_#{for_file.chomp(File.extname(for_file))}.jpg"
  end

  def set_content_type_jpeg
    # https://github.com/evrone/carrierwave-video-thumbnailer/issues/6
    self.file.instance_variable_set(:@content_type, "image/jpeg")
  end
end

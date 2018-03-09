class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::Video
  include CarrierWave::Video::Thumbnailer


  IMAGE_EXTENSIONS = %w(jpg jpeg gif png)
  VIDEO_EXTENSIONS = %w(mov avi mp4 mkv wmv mpg)

  process :save_file_type_in_model
  process :save_file_specification

  version :thumb, if: :is_image? do
    process resize_to_fill: [200,200]
  end

  version :video_thumb, if: :is_video? do
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

  version :mp4, if: :is_not_mp4_video? do
    process encode_video: [
      :mp4,
      audio_codec: 'aac',
      video_codec: 'libx264',
      custom: '-pix_fmt yuv420p -strict experimental'
    ]

    def full_filename for_file
      mp4_name for_file
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def full_mp4_url
    path = is_not_mp4_video?(file) ? mp4.url : url
    path
    # Rails.application.secrets.domain_name + path
  end

  def full_video_thumb_url
    video_thumb.url
    # Rails.application.secrets.domain_name + video_thumb.url
  end

  def filename
    # need to make sure product_file filenames are uniq in scope of one Product
    if original_filename.present?
      orig = File.basename(original_filename, '.*')
      original_filenam="#{orig}_#{uniq_token}.#{file.extension}"
    end
  end

  private
  def save_file_type_in_model
    return unless model && file
    Uploaders::SaveContentTypeService.new(model, file).call
  end

  def save_file_specification
    return unless model && file

    if is_image?(file)
      Uploaders::SaveImageSpecificationService.new(model, file).call
    elsif is_video?(file)
      Uploaders::SaveVideoSpecificationService.new(model, file).call
    end
  end

  def is_image? file
    file.content_type.match(/image\//)
  end

  def is_video? file
    file.content_type.match(/video\//)
  end

  def is_not_mp4_video? file
    file.content_type.match(/video\//) && !file.content_type.match(/video\/mp4/)
  end

  def png_name for_file, version_name
    "#{version_name}_#{for_file.chomp(File.extname(for_file))}.jpg"
  end

  def set_content_type_jpeg
    # https://github.com/evrone/carrierwave-video-thumbnailer/issues/6
    self.file.instance_variable_set(:@content_type, "image/jpeg")
  end

  def mp4_name for_file
    "#{File.basename(for_file, File.extname(for_file))}_converted.mp4"
  end

  protected

  def uniq_token(length=10)
    var = :"@#{mounted_as}_secure_token"
    _token = rand(36**length).to_s(36)
    model.instance_variable_get(var) or model.instance_variable_set(var, _token)
  end

end

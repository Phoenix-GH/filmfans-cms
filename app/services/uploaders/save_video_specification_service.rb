class Uploaders::SaveVideoSpecificationService
  def initialize(model, file)
    @model = model
    @file = file
  end

  def call
    return false unless @model.respond_to?(:specification)
    save_file_specification

    true
  end

  private
  def save_file_specification
    video = FFMPEG::Movie.new(@file.file)
    specification = {
      height: video.height,
      width: video.width,
      duration: video.duration,
      video_codec: video.video_codec,
      audio_codec: video.audio_codec,
      valid: video.valid?
    }

    @model.specification = specification
  end
end

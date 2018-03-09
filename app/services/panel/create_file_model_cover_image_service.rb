class Panel::CreateFileModelCoverImageService
  def initialize(file_model)
    @file_model = file_model
  end

  def call
    if Rails.env.production?
      create_cover_image_from_aws_server
    else
      create_cover_image_locally
    end
  end

  private
  def create_cover_image_from_aws_server
    if @file_model.image?
      @file_model.update_attributes(
        remote_cover_image_url: @file_model.file.url
      )
    elsif @file_model.video?
      @file_model.update_attributes(
        remote_cover_image_url: @file_model.file.video_thumb.url
      )
    end
  end

  def create_cover_image_locally
    if @file_model.image?
      @file_model.update_attributes(
        cover_image: @file_model.file
      )
    elsif @file_model.video?
      @file_model.update_attributes(
        cover_image: @file_model.file.video_thumb
      )
    end
  end
end

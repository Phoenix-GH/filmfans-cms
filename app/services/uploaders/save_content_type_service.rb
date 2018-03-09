class Uploaders::SaveContentTypeService
  def initialize(model, file)
    @model = model
    @file = file
  end

  def call
    fix_carrierwave_bug
    save_file_content_type

    true
  end

  private
  def fix_carrierwave_bug
    # https://github.com/carrierwaveuploader/carrierwave/issues/1841
    if @file.content_type == 'application/mp4'
      @file.content_type = 'video/mp4'
    end
  end

  def save_file_content_type
    @model.file_type = @file.content_type if @file.content_type
  end
end

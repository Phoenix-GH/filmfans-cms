class Uploaders::SaveImageSpecificationService
  def initialize(model, file)
    @model = model
    @file = file
  end

  def call
    save_file_specification

    true
  end

  private
  def save_file_specification
    image = ::MiniMagick::Image.open(@file.file)
    specification = { height: image.height, width: image.width }

    @model.specification = specification
  end
end

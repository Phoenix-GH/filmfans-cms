class SnappedProductPictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def fog_attributes
    {'Content-Type' => 'image/jpeg'}
  end

  version :thumb do
    process resize_to_limit: [200, 200]
  end

  version :small_thumb do
    process resize_to_limit: [100, 100]
  end

  version :cropped do
    process :do_cropping
  end

  def filename
    if original_filename.present?
      orig = File.basename(original_filename, '.*')
      "#{orig}_#{uniq_token}.jpg"
    end
  end

  def store_dir
    "uploads/crop_and_shop/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def content_type_whitelist
    /image\//
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path(
        "fallback/" + [version_name, "default_picture.png"].compact.join('_')
    )
  end

  def full_url
    url
  end

  def thumb_url
    thumb.url
  end

  def small_thumb_url
    small_thumb.url
  end

  def cropped_url
    cropped.url
  end

  def img_dimension
    if file.respond_to?(:file)
      # local
      ::MiniMagick::Image.open(file.file)[:dimensions]
    else
      # S3 with Fog
      ::MiniMagick::Image.open(file.url)[:dimensions]
    end
  end

  protected
  def uniq_token(length=10)
    var = :"@#{mounted_as}_secure_token"
    _token = rand(36**length).to_s(36)
    model.instance_variable_get(var) or model.instance_variable_set(var, _token)
  end

  private

  def do_cropping
    if model.respond_to?(:details) && model.details['image_parameters'].present?
      manipulate! do |img|
        area = model.details['image_parameters']

        x = area['x'].to_i
        y = area['y'].to_i
        width = area['width'].to_i
        height = area['height'].to_i

        do_crop(img, x, y, width, height)
      end
    end
  end

  def do_crop(img, x, y, width, height)
    ImageHelper::crop(img, x, y, width, height)
  end

end

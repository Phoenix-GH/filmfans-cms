class BenchmarkMultiObjectCropUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :do_cropping

  def fog_attributes
    {'Content-Type' => 'image/jpeg'}
  end

  def filename
    if original_filename.present?
      orig = File.basename(original_filename, '.*')
      "#{orig}_#{uniq_token}.jpg"
    end
  end

  def store_dir
    "uploads/crop_and_shop/#{ExecutionBenchmark.to_s.underscore}/#{model.execution_benchmark.id}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def content_type_whitelist
    /image\//
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path(
        "fallback/" + [version_name, "default_picture.png"].compact.join('_')
    )
  end

  protected
  def uniq_token(length=10)
    var = :"@#{mounted_as}_secure_token"
    _token = rand(36**length).to_s(36)
    model.instance_variable_get(var) or model.instance_variable_set(var, _token)
  end

  private

  def do_cropping
    if model.respond_to?(:area) && model.area.present?
      manipulate! do |img|
        area = model.area
        do_crop(img, area[0], area[1], area[2], area[3])
      end
    end
  end

  def do_crop(img, x, y, x2, y2)
    ori_width = img[:width]
    ori_height = img[:height]

    # add 10px padding surround the crop for the single-object classifier
    padding = 0 #10

    x = x.to_i - padding
    y = y.to_i - padding
    width = (x2 - x).to_i + (2 * padding)
    height = (y2 - y).to_i + (2 * padding)

    x = x < 0 ? 0 : x
    y = y < 0 ? 0 : y
    width = width > ori_width ? ori_width : width
    height = height > ori_height ? ori_height : height

    img.crop "#{width}x#{height}+#{x}+#{y}"
    img
  end
end
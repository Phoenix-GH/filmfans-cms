class CategoryUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :carousel do
    process resize_to_fit: [220, -1]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def content_type_whitelist
    /image\//
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path(
      "fallback/" + [version_name, "default_picture.png"].compact.join('_')
    )
  end
end

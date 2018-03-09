class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fit: [1125, -1]

  version :media_container_size do
    process resize_to_fit: [1080, -1]
  end

  version :combo_container_size do
    process resize_to_fit: [540, -1]
  end

  version :thumb do
    process resize_to_limit: [200, 200]
  end

  version :small_thumb do
    process resize_to_limit: [100, 100]
  end

  def filename
    # need to make sure product_file filenames are uniq in scope of one Product
    if original_filename.present?
      orig = File.basename(original_filename, '.*')
      "#{orig}_#{uniq_token}.#{file.extension}"
    end
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

  def full_url
    url
    # Rails.application.secrets.domain_name + url
  end

  def full_thumb_url
    thumb.url
    # Rails.application.secrets.domain_name + thumb.url
  end

  protected
  def uniq_token(length=10)
    var = :"@#{mounted_as}_secure_token"
    _token = rand(36**length).to_s(36)
    model.instance_variable_get(var) or model.instance_variable_set(var, _token)

  end
end

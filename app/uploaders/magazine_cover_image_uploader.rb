class MagazineCoverImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :custom do
    process :zoom_and_crop
  end

  def zoom_and_crop
    model.update_column(:specification, {}) if (model.persisted? && model.file_changed?)
    if model.class.to_s == 'MagazineCoverImage' && model.respond_to?(:specification) && model.specification['crop_x'].present?
      manipulate! do |img|
        oriWidth = img[:width]
        oriHeight = img[:height]

        x = model.specification['crop_x'].to_i
        y = model.specification['crop_y'].to_i
        width = model.specification['width'].to_i
        height = model.specification['height'].to_i

        x = x < 0 ? 0 : x
        y = y < 0 ? 0 : y
        width = width > oriWidth ? oriWidth : width
        height = height > oriHeight ? oriHeight : height

        img.crop "#{width}x#{height}+#{x}+#{y}"
        img
      end
      resize_and_pad model.specification['width'].to_i, model.specification['height'].to_i
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id % 255}/#{(model.id/2) % 255}/#{model.id}"
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

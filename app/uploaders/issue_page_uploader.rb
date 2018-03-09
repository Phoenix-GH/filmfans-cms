class IssuePageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # when adding new versions, remember to update the following file
  # issue_page.rb
  # magazine_image_page_compressor_job.rb

  version :thumbnail do
    process resize_to_fit: [300, 300]
  end

  version :quality_100 do
    process :jpeg_quality => 100

    def full_filename (for_file)
      change_file_extension(super(for_file), 'jpg')
    end
  end

  version :quality_95 do
    process :jpeg_quality => 95

    def full_filename (for_file)
      change_file_extension(super(for_file), 'jpg')
    end
  end

  version :quality_85 do
    process :jpeg_quality => 85

    def full_filename (for_file)
      change_file_extension(super(for_file), 'jpg')
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

  private
  def change_file_extension(file_name, new_extension)
    if file_name
      extension = File.extname(file_name)
      base_name = file_name.chomp(extension)
      base_name + "." + new_extension
    end
  end
end

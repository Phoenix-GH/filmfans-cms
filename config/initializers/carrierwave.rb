if Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = true
    config.asset_host = 'http://localhost:3000'
  end
elsif Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

  # make sure our uploader is auto-loaded
  FileUploader
  PictureUploader
  CategoryUploader
  VideoUploader
  AvatarUploader

  # use different dirs when testing
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do
      def cache_dir
        "#{Rails.root}/spec/support/uploads/tmp"
      end

      def store_dir
        "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_STORE_REGION'],
      endpoint: "https://s3-#{ENV['AWS_STORE_REGION']}.amazonaws.com"
    }
    config.fog_directory  = ENV['AWS_STORE_DIRECTORY']
    config.fog_public     = true
    unless ENV['AWS_CDN_HOST'].blank?
      config.asset_host = "https://#{ENV['AWS_CDN_HOST']}"
    end
  end
end

# https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Specify-the-image-quality
module CarrierWave
  module MiniMagick
    def jpeg_quality(percentage)
      manipulate! do |img|
        img.strip
        unless img.mime_type.match /image\/jpeg/
          img = img.format('JPEG')
        end
        img.combine_options do |c|
          c.quality(percentage.to_s)
          c.depth "8"
          c.interlace "plane"
        end

        img = yield(img) if block_given?
        img
      end
    end
  end
end

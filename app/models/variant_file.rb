class VariantFile
  include ActiveModel::Model
  extend CarrierWave::Mount

  attr_accessor :id, :variant_id, :file_type, :file, :cover_image, :specification,
                :small_version_url, :normal_version_url, :large_version_url

  mount_uploader :cover_image, PictureUploader
  mount_uploader :file, FileUploader

  # serialize :specification, JSON

  def initialize(params={})
    unless params.blank?
      # @_file_type = params['file_type']
      @_file = params['file']
      @_cover_image = params['cover_image']
    end

    super(params)
  end

  def variant=(variant)
    self.variant_id = variant.id
  end

  def read_uploader(param)
    if param == :file
      @_file
    elsif param == :cover_image
      @_cover_image
    end
  end

  def id
    # This is requirement of Carrierwave
    # We want to store all product related product_files
    # in Carrierwave uploads/product_id/directory/...
    self.variant_id
  end

  def save
    self.store_file!
    self.store_cover_image!
  end
  alias :save! :save

  def attributes
    {
      id: self.id,
      variant_id: self.variant_id,
      file_type: self.file_type,
      file: self.file.path && File.basename(self.file.path),
      cover_image: self.cover_image.path && File.basename(self.cover_image.path),
      specification: self.specification,
      small_version_url: self.small_version_url,
      normal_version_url: self.normal_version_url,
      large_version_url: self.large_version_url,
    }
  end

  def mp4_version_file
    file_type.match('video/mp4') ? file : file.mp4
  end

  def image?
    file_type.match('image/')
  end

  def video?
    file_type.match('video/')
  end

  def small_cover_image_url
    if cover_image.present?
      cover_image&.small_thumb.url.to_s
    else
      small_version_url.to_s
    end
  end

  def thumb_cover_image_url
    if cover_image.present?
      cover_image&.thumb.url.to_s
    else
      normal_version_url.to_s
    end
  end

  def large_cover_image_url
    if cover_image.present?
      cover_image.url.to_s
    else
      large_version_url.to_s
    end
  end
end

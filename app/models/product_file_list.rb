# This is a temporary solution to solve the problem of no image will be displayed
# because the column product_files in table products is empty.
# This class and its references in the Product class will be deleted once the DB is updated
# and the table product_files is removed.
class ProductFileList < ActiveRecord::Base
  self.table_name = 'product_files'

  belongs_to :product_files_list, class_name: 'Product'

  mount_uploader :cover_image, PictureUploader
  mount_uploader :file, FileUploader

  def readonly?
    true
  end


  def small_cover_image_url
    if cover_image.present? && url_available?(cover_image.small_thumb&.url)
      cover_image.small_thumb&.url.to_s
    else
      small_version_url.to_s
    end
  end

  def thumb_cover_image_url
    if cover_image.present? && url_available?(cover_image.thumb&.url)
      cover_image.thumb&.url.to_s
    else
      normal_version_url.to_s
    end
  end

  def large_cover_image_url
    if cover_image.present? && url_available?(cover_image.url)
      cover_image.url.to_s
    else
      large_version_url.to_s
    end
  end

  private

  def url_available?(url)
    !url.nill? && !url.empty? && url.casecmp('None') != 0
  end

end


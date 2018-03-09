class IssuePage < ActiveRecord::Base
  belongs_to :issue
  has_many :issue_page_tags, dependent: :destroy
  has_many :products, through: :issue_page_tags

  mount_uploader :image, IssuePageUploader

  scope :having_out_stock_products, -> {
    joins(:products)
        .where(products: {available: false})
        .select("'#{IssuePage.name}' AS type")
        .select(:id)
  }

  def thumbnail_url
    return '' unless image.present?
    image.thumbnail.url.to_s
  end

  def quality_100_url
    return '' unless image.present?
    image.quality_100.url.to_s
  end

  def quality_95_url
    return '' unless image.present?
    image.quality_95.url.to_s
  end

  def quality_85_url
    return '' unless image.present?
    image.quality_85.url.to_s
  end

  def image_url_for_apps
    config_version = ENV['MAGAZINE_ISSUE_PAGE_IMAGE_DEF_VERSION']

    if config_version == 'quality_100'
      quality_100_url
    elsif config_version == 'quality_95'
      quality_95_url
    elsif config_version == 'quality_85'
      quality_85_url
    else
      full_size_url
    end
  end

  def full_size_url
    return '' unless image.present?
    image.url.to_s
  end

  # WARNING: this method is slow as it calls to S3 to check for physical file
  def thumbnail_image_exists?
    image.present? and image.thumbnail.file.exists?
  end

  # WARNING: this method is slow as it calls to S3 to check for physical file
  def quality_100_image_exists?
    image.present? and image.quality_100.file.exists?
  end

  # WARNING: this method is slow as it calls to S3 to check for physical file
  def quality_95_image_exists?
    image.present? and image.quality_95.file.exists?
  end

  # WARNING: this method is slow as it calls to S3 to check for physical file
  def quality_85_image_exists?
    image.present? and image.quality_85.file.exists?
  end

end
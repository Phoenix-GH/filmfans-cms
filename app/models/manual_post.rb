class ManualPost < ActiveRecord::Base
  include BaseCropableImageRecord

  DISPLAY_TRENDING_ONLY = 0
  DISPLAY_SOCIAL_ONLY = 1
  DISPLAY_BOTH = 2

  # either
  belongs_to :channel
  belongs_to :media_owner

  has_many :manual_post_products, dependent: :destroy
  has_many :products, through: :manual_post_products
  has_many :linked_manual_posts, dependent: :destroy

  mount_uploader :image, CropableImageUploader
  mount_uploader :video, VideoUploader

  serialize :specification, JSON

  default_scope { order(created_at: :desc) }
  scope :visible, -> { where(visible: true) }
  scope :video, -> { where.not(video: nil) }
  scope :until, -> (timestamp) { where('created_at <= ?', Time.at(timestamp)) }
  scope :media_owners, -> { where('media_owner_id IS NOT NULL') }
  scope :channels, -> { where('channel_id IS NOT NULL') }
  scope :social, -> { where('display_option != (?)', ManualPost::DISPLAY_TRENDING_ONLY) }
  scope :trending, -> { where('display_option != (?)', ManualPost::DISPLAY_SOCIAL_ONLY) }
  scope :having_out_stock_products, -> {
    joins(:products)
        .where(products: {available: false})
        .select("'#{ManualPost.name}' as type")
        .select(:id) }

  def first_product
    products&.first
  end

  def owner_name
    unless channel.nil?
      return channel.name
    end
    media_owner.nil? ? '' : media_owner.name
  end

  def owner_avatar
    unless channel.nil?
      return channel.picture&.custom_url
    end
    media_owner.nil? ? '' : media_owner.picture&.custom_url
  end

  def image?
    !custom_url.blank?
  end

  def video?
    !video.blank?
  end

  def update_url
    "/panel/#{self.class.to_s.underscore}s/#{id}/update_crop_area"
  end

  def source_owner
    if media_owner_id.nil?
      channel
    else
      media_owner
    end
  end

  def image_file_changed?
    image_changed?
  end

  def full_image_file_url
    image_url
  end

  protected

  def mounted_image_attribute
    image
  end

  def cropper_type
    'grid-with-product'
  end
end

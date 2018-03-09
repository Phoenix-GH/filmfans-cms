class Post < ActiveRecord::Base
  belongs_to :source
  has_many :post_products, dependent: :destroy
  has_many :products, through: :post_products

  mount_uploader :content_picture, PictureUploader
  mount_uploader :content_video, VideoUploader

  delegate :website, :source_owner, to: :source

  validates :uid, uniqueness: true

  enum post_type: [:image, :video]

  default_scope { order(published_at: :desc) }
  scope :last_three_months, -> { where('published_at > ?', 3.months.ago) }
  scope :visible, -> { where(visible: true) }
  scope :until, -> (timestamp) { where('published_at <= ?', Time.at(timestamp)) }
  scope :having_out_stock_products, -> {
    joins(:products)
        .where(products: {available: false})
        .select("'#{Post.name}' AS type")
        .select(:id)
  }

end

class ProductsContainer < ActiveRecord::Base
  has_many :linked_products, dependent: :destroy
  has_many :products, through: :linked_products
  has_many :collection_contents, as: :content, dependent: :destroy
  has_one :media_content, as: :membership, dependent: :destroy

  belongs_to :category
  belongs_to :media_owner
  belongs_to :channel
  belongs_to :admin

  accepts_nested_attributes_for :linked_products, allow_destroy: true

  scope :classic, -> { where(media_owner_id: nil) }
  scope :combo, -> { where.not(media_owner_id: nil) }
  scope :having_out_stock_products, -> {
    joins(:products)
        .where(products: {available: false})
        .select("'#{ProductsContainer.name}' AS type")
        .select(:id)
  }

  include Translation
  translate :name

  def cover_image
    products.first&.cover_image
  end

  def cover_image_url
    products.first&.cover_image_url
  end

  def second_cover_image_url
    products.second&.cover_image_url
  end

  def third_cover_image_url
    products.third&.cover_image_url
  end

  def cover_images_urls
    products.map(&:cover_image_url)
  end
end

class TrendingContent < ActiveRecord::Base
  belongs_to :trending
  belongs_to :content, polymorphic: true
  belongs_to :product, ->{ where(trending_contents:  {:content_type => 'Product'}) }, foreign_key: 'content_id'

  scope :having_out_stock_products, -> {
    joins(:product)
        .where(products: {available: false})
        .select("'#{TrendingContent.name}' AS type")
        .select(:id) }
end

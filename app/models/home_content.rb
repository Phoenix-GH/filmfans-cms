class HomeContent < ActiveRecord::Base
  belongs_to :home
  belongs_to :content, polymorphic: true
  belongs_to :product, -> { where(home_contents: {:content_type => 'Product'}) }, foreign_key: 'content_id'

  scope :having_out_stock_products, -> {
    joins(:product)
        .where(products: {available: false})
        .select("'#{HomeContent.name}' as type")
        .select(:id) }
end

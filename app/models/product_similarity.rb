class ProductSimilarity < ActiveRecord::Base
  self.table_name = "product_similarity"

  belongs_to :product_from, class_name: 'Product'
  belongs_to :product_to, class_name: 'Product'
end

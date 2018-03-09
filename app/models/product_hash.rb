class ProductHash < ActiveRecord::Base
  self.primary_key = "product_id"
  belongs_to :product, foreign_key: "product_id"
end
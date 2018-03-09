class ProductCategory < ActiveRecord::Base
  belongs_to :product
  belongs_to :category

  after_commit :reindex_product

  def reindex_product
    product.reindex
  end

end

class Trending < ActiveRecord::Base
  has_many :trending_contents, dependent: :destroy
  has_many :products_containers,
    through: :trending_contents,
    source: :content,
    source_type: 'ProductsContainer'
  has_many :collections_containers,
    through: :trending_contents,
    source: :content,
    source_type: 'CollectionsContainer'
  has_many :media_containers,
    through: :trending_contents,
    source: :content,
    source_type: 'MediaContainer'
  has_many :single_product_containers,
    through: :trending_contents,
    source: :content,
    source_type: 'Product'

  belongs_to :channel
end

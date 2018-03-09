class ProductKeyword < ActiveRecord::Base
  self.primary_key = 'product_id'
  belongs_to :product, foreign_key: 'product_id'
  has_many :variants, foreign_key: 'product_id'

  # bundle exec rake searchkick:reindex CLASS=ProductKeyword RAILS_ENV=development
  # http://localhost:9200/_aliases?pretty=1
  # http://localhost:9200/product_keywords_development/_mapping
  # default is "word" mode
  # bundle exec rake searchkick:reindex CLASS=ProductKeyword RAILS_ENV=development
  searchkick phase: [:ibm_keywords], special_characters: false

  def displayed_keywords_as_array
    ibm_keywords_as_array
  end

  def search_data
    {
        id: id,
        brand: brand,
        ibm_keywords: ibm,
        store: store_id
        #app: => products.app
    }
  end

  def ibm
    kws = ibm_keywords_as_array
    return nil if kws.blank?

    kws << brand

    kws.compact
  end

  def ibm_keywords_as_array
    return [] if ibm_keywords.blank?
    ibm_keywords.map { |k|
      ProductKeyword::normalize_keyword(k['name'])
    }.compact
  end

  def self.normalize_keyword(kw)
    return kw if kw.blank?

    kw&.downcase
        &.gsub(/( color)$/, '') # blue color => blue
        &.gsub(/( colour)$/, '')
        &.gsub(/\(.*\)/, '') # peplum (of garment) => peplum
        &.strip
        &.squeeze(' ') # remove redundant spaces
  end

  def store_id
    s = self.class.joins(variants: :variant_stores).
        select('variant_stores.store_id as store_id').
        where(product_keywords: {product_id: self.product_id}).
        first

    return nil if s.blank?
    s[:store_id]
  end

  def brand
    product.brand
        &.downcase
        &.strip
        &.squeeze(' ') # remove redundant spaces
  end
end
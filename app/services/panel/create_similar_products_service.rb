class Panel::CreateSimilarProductsService
  def initialize(object, similar_product_ids = [])
    @object = object
    @similar_product_ids = similar_product_ids
  end

  def call
    ActiveRecord::Base.transaction do
      remove_old_product_similarity
      create_new_product_similarity
    end
  end

  private

  def remove_old_product_similarity
    ProductSimilarity.where(product_from: @object).delete_all
    ProductSimilarity.where(product_to: @object).delete_all
  end

  def create_new_product_similarity
    @similar_product_ids.each do |id|
      ProductSimilarity.create(product_from: @object, product_to_id: id)
      ProductSimilarity.create(product_to: @object, product_from_id: id)
    end
  end
end

class MediaOwnerForCategoryQuery
  def initialize(category_id)
    @category_id = category_id
  end

  def results
    prepare_products
    products_containers_owners
    media_containers_owners
    all_media_owners
  end

  private

  def prepare_products
    @products = ProductCategory.where(category_id: @category_id).pluck(:product_id)
  end

  def products_containers_owners
    @products_containers_owners_ids = ProductsContainer.joins(:linked_products)
      .where(linked_products: { product_id: @products })
      .where.not(media_owner_id: nil)
      .pluck(:media_owner_id)
  end

  def media_containers_owners
    @media_containers_owners_ids = MediaContainer.joins(:tags)
      .where(tags: { product_id: @products })
      .where(owner_type: 'MediaOwner')
      .where.not(owner_id: nil)
      .pluck(:owner_id)
  end

  def all_media_owners
    (@products_containers_owners_ids + @media_containers_owners_ids).uniq
  end
end

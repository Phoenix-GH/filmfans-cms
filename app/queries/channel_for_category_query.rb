class ChannelForCategoryQuery
  def initialize(category_id)
    @category_id = category_id
  end

  def results
    prepare_products
    products_containers_channels
    media_containers_channels
    all_channels
  end

  private

  def prepare_products
    @product_ids = ProductCategory.where(category_id: @category_id).pluck(:product_id)
  end

  def products_containers_channels
    @products_containers_channels_ids = ProductsContainer.joins(:linked_products)
      .where(linked_products: { product_id: @product_ids })
      .where.not(channel_id: nil)
      .pluck(:channel_id)
  end

  def media_containers_channels
    @media_containers_channels_ids = MediaContainer.joins(:tags)
      .where(tags: { product_id: @product_ids })
      .where.not(owner_id: nil)
      .where(owner_type: 'Channel')
      .pluck(:owner_id)
  end

  def all_channels
    (@products_containers_channels_ids + @media_containers_channels_ids).uniq
  end
end

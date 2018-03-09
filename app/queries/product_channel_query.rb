class ProductChannelQuery
  def initialize(channel_ids)
    @channel_ids = channel_ids
  end

  def results
    channel_linked_products
    channel_tag_products
    (@owner_tag_products + @owner_linked_products).uniq

  end

  private

  def channel_linked_products
    @owner_linked_products = LinkedProduct.joins(:products_container)
      .where(products_containers: { channel_id: @channel_ids })
      .where.not(products_containers: { channel_id: nil })
      .pluck(:product_id)
  end

  def channel_tag_products
    @owner_tag_products = Tag.joins(:media_container)
      .where(media_containers: { owner_id: @channel_ids, owner_type: 'Channel' })
      .where.not(media_containers: { owner_id: nil })
      .pluck(:product_id)
  end

end

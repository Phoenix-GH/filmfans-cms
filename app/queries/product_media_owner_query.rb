class ProductMediaOwnerQuery
  def initialize(media_owner_ids)
    @media_owner_ids = media_owner_ids
  end

  def results
    owner_linked_products
    owner_tag_products
   (@owner_tag_products + @owner_linked_products).uniq

  end

  private

  def owner_linked_products
    @owner_linked_products = LinkedProduct.joins(:products_container)
      .where(products_containers: { media_owner_id: @media_owner_ids })
      .where.not(products_containers: { media_owner_id: nil })
      .pluck(:product_id)
  end

  def owner_tag_products
    @owner_tag_products = Tag.joins(:media_container)
      .where(media_containers: { owner_id: @media_owner_ids, owner_type: 'MediaOwner'})
      .where.not(media_containers: { owner_id: nil })
      .pluck(:product_id)
  end

end

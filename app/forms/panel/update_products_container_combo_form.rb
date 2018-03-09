class Panel::UpdateProductsContainerComboForm
  include ActiveModel::Model

  attr_reader :media_content
  attr_accessor(
      :id, :description, :name, :product_ids, :media_owner_id, :media_content_id, :channel_id
  )

  def initialize(products_container_attrs, form_attributes = {})
    super products_container_attrs.merge(form_attributes)

    @media_content = MediaContent.find(media_content_id) if media_content_id.present?
  end

  validates :name, :product_ids, presence: true
  validates :media_content_id, media_content_presence: true, if: :media_owner?

  def products_container_attributes
    {
        name: name,
        description: description,
        product_ids: products_linked,
        media_owner_id: media_owner_id,
        channel_id: channel_id,
        media_content: @media_content
    }
  end

  def products_linked
    if product_ids
      product_ids.split(",")
    else
      products_container = ProductsContainer.find(id)
      products_container ? products_container.product_ids : []
    end
  end

  private
  def media_owner?
    media_owner_id.present?
  end
end

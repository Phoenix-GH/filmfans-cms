class Panel::CreateProductsContainerComboForm
  include ActiveModel::Model

  attr_reader :media_content
  attr_accessor(
      :name, :description, :product_ids, :media_owner_id, :media_content_id, :channel_id
  )

  validates :name, :product_ids, presence: true
  validates :media_content_id, media_content_presence: true, if: :media_owner?

  def initialize(attributes = {})
    super(attributes)
    @media_content = MediaContent.find(media_content_id) if media_content_id.present?
  end

  def products_container_attributes
    {
        name: name,
        description: description,
        product_ids: products_linked,
        media_owner_id: media_owner_id,
        media_content: @media_content,
        channel_id: channel_id
    }
  end

  def products_linked
    product_ids ? product_ids.split(",") : []
  end

  private
  def media_owner?
    media_owner_id.present?
  end
end

class Panel::UpdateCollectionForm
  include ActiveModel::Model

  attr_accessor(
    :id, :name, :background_image, :cover_image
  )

  def initialize(collection_attrs, form_attributes = {})
    @attributes = collection_attrs.merge(form_attributes)
    super @attributes
  end

  def collection_attributes
    {
      name: name
    }
  end

  def background_image_attributes
    background_image || {}
  end

  def cover_image_attributes
    background_image_attributes
  end
end

class Panel::UpdateCollectionService
  def initialize(collection, form)
    @collection = collection
    @form = form
  end

  def call
    return false unless @form.valid?

    update_collection
  end

  private

  def update_collection
    @collection.update_attributes(@form.collection_attributes)
    @collection.cover_image.update_attributes(@form.cover_image_attributes)
    @collection.background_image.update_attributes(@form.background_image_attributes)
  end
end

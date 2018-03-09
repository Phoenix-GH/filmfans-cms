class Panel::UpdateCollectionsContainerService
  def initialize(collections_container, form)
    @collections_container = collections_container
    @form = form
  end

  def call
    return false unless @form.valid?

    update_collections_container
    add_linked_collections
  end

  def products_container
    @collections_container
  end

  private

  def update_collections_container
    @collections_container.update_attributes(@form.collections_container_attributes)
  end

  def add_linked_collections
    Panel::CreateLinkedCollectionService.new(@collections_container, @form.linked_collections).call
  end

end

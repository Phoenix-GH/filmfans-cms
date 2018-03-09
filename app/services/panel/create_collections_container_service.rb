class Panel::CreateCollectionsContainerService
  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    create_collections_container
    add_linked_collections
    add_admin_id
  end

  def collections_container
    @collections_container
  end

  private
  def create_collections_container
    @collections_container = CollectionsContainer.create(@form.collections_container_attributes)
  end

  def add_linked_collections
    Panel::CreateLinkedCollectionService.new(@collections_container, @form.linked_collections).call
  end

  def add_admin_id
    if @user.role == 'moderator'
      @collections_container.update_attributes(admin_id: @user.id)
    end

    true
  end
end

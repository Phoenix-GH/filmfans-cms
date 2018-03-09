class Panel::UpdateManualPostContainerService
  def initialize(manual_post_container, form)
    @manual_post_container = manual_post_container
    @form = form
  end

  def call
    return false unless @form.valid?

    update_manual_post_container
    add_linked_manual_posts
  end

  def products_container
    @manual_post_container
  end

  private

  def update_manual_post_container
    @manual_post_container.update_attributes(@form.manual_post_container_attributes)
  end

  def add_linked_manual_posts
    Panel::CreateLinkedManualPostsService.new(@manual_post_container, @form.linked_manual_posts).call
  end

end

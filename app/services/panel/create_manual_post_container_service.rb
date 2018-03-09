class Panel::CreateManualPostContainerService
  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      create_container
      add_linked_manual_posts
    end
  end

  def manual_post_container
    @manual_post_container
  end

  private
  def create_container
    @manual_post_container = ManualPostContainer.create(@form.manual_post_container_attributes)
  end

  def add_linked_manual_posts
    Panel::CreateLinkedManualPostsService.new(@manual_post_container, @form.linked_manual_posts).call
  end
end

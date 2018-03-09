class Panel::UpdateHomeContentsService
  def initialize(home, form)
    @home = home
    @form = form
  end

   def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      remove_old_home_contents
      create_new_home_contents
    end
  end

  private
  def remove_old_home_contents
    @home.home_contents.delete_all
  end

  def create_new_home_contents
    @form.home_contents.each_with_index do |content, index|
      model = content[:content_type]
      model_id = content[:content_id]

      if model_id && model && home_content = model.constantize.find_by(id: model_id)
        if %w(MediaOwner Channel Event TvShow Magazine).include?(model)
          home_content = Link.create(target: home_content)
        end
        @home.home_contents.create(
          content: home_content,
          width: set_width(content),
          position: index
        )
      end
    end
  end

  def set_width(content)
    model = content[:content_type]
    if content[:width] == '1' || %w(ProductsContainer CollectionsContainer EventsContainer).include?(model)
      'full'
    else
      'half'
    end
  end

end

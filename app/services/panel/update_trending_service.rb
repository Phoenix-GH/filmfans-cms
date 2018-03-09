class Panel::UpdateTrendingService
  def initialize(trending, form)
    @trending = trending
    @form = form
  end

   def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      remove_old_trending_contents
      create_new_trending_contents
    end
  end

  private
  def remove_old_trending_contents
    @trending.trending_contents.delete_all
  end

  def create_new_trending_contents
    @form.trending_contents.each_with_index do |content, index|
      model = content[:content_type]
      model_id = content[:content_id]
      width = (content[:width] == '1' || model == 'EventsContainer') ? 'full' : 'half'

      if model_id && model && trending_content = model.constantize.find(model_id)
        if %w(MediaOwner Channel Event TvShow Magazine).include?(model)
          trending_content = Link.create(target: trending_content)
        end
        @trending.trending_contents.create(
          content: trending_content,
          width: width,
          position: index
        )
      end
    end
  end

end

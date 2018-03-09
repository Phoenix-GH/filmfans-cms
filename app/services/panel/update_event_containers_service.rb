class Panel::UpdateEventContainersService
  def initialize(event, form)
    @event = event
    @form = form
  end

   def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      remove_old_event_contents
      create_new_event_contents
    end
  end

  private
  def remove_old_event_contents
    @event.event_contents.delete_all
  end

  def create_new_event_contents
    @form.event_contents.each_with_index do |content, index|
      model = content[:content_type]
      model_id = content[:content_id]
      width = content[:width] == '1' ? 'full' : 'half'

      if model_id && model && event_content = model.constantize.find(model_id)
        @event.event_contents.create(
          content: event_content,
          width: width,
          position: index
        )
      end
    end
  end

end

class Panel::EventsController < Panel::BaseController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :update_images]

  def index
    authorize! :read, Event
    @events = EventQuery.new(event_search_params).results
  end

  def show
    authorize! :read, @event
  end

  def new
    authorize! :create, Event
    @background_image = EventBackgroundImage.new
    @form =  Panel::CreateEventDetailsForm.new
  end

  def create
    authorize! :create, Event
    @form = Panel::CreateEventDetailsForm.new(event_form_params)
    service = Panel::CreateEventDetailsService.new(@form, current_user)

    if service.call
      redirect_to edit_panel_event_path(service.event, step: :containers)
    else
      render :new
    end
  end

  def edit
    authorize! :update, @event
    @background_image = @event.background_image || @event.create_background_image
    @form = Panel::UpdateEventDetailsForm.new(event_attributes)
    step = params[:step] || 'details'
    if step == 'details'
      @form = Panel::UpdateEventDetailsForm.new(event_attributes)
      render :edit_details
    elsif step == 'containers'
      @form = Panel::UpdateEventContainersForm.new(containers_attributes)
      render :edit_containers
    end
  end

  def update
    authorize! :update, @event

    step = params[:step] || 'details'
    if step == 'details'
      @form = Panel::UpdateEventDetailsForm.new(
        event_attributes,
        event_form_params
      )
      service = Panel::UpdateEventDetailsService.new(@event, @form)
      if service.call
        redirect_to edit_panel_event_path(@event, step: :containers)
      else
        render :edit_details
      end
    elsif step == 'containers'
      @form = Panel::UpdateEventContainersForm.new(
        containers_attributes,
        containers_form_params
      )
      service = Panel::UpdateEventContainersService.new(@event, @form)
      if service.call
        redirect_to panel_events_path
      else
        render :edit_containers
      end
    else
      redirect_to panel_events_path
    end
  end

  def destroy
    authorize! :destroy, @event
    @event.destroy

    redirect_to panel_events_path, notice: _('Event was successfully deleted.')
  end

  def update_images
    authorize! :update, @event
    @event.cover_image.update_attributes(cover_image_params)
    @event.cover_image.file.recreate_versions!
    @event.background_image.update_attributes(background_image_params)
    @event.background_image.file.recreate_versions!

    render 'background_image', layout: false
  end

  private
  def set_event
    @event = Event.find(params[:id])
  end

  def event_attributes
    @event.slice('name')
  end

  def event_form_params
    params.require(:event_form).permit(:name, background_image: [:file])
  end

  def event_search_params
    params.permit(:sort, :direction, :search).merge(admin_id: current_admin.id)
  end

  def containers_attributes
    { event_contents: @event.event_contents.order(:position)
      .select(:id, :content_type, :content_id, :position, :width)
    }
  end

  def containers_form_params
    params.require(:event_contents_form).permit(
      event_contents_attributes:
      [:content_type, :content_id, :_destroy, :id, :position, :width]
    )
  end

  def sort_column
    ['created_at', 'name', 'event_contents'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_params
    params.require(:order)
  end

  def cover_image_params
    params.require(:cover_image).permit(specification: [:crop_x, :crop_y, :width, :height, :zoom, :cropBox_x, :cropBox_y, :cropBox_width, :cropBox_height])
  end

  def background_image_params
    params.require(:background_image).permit(specification: [:crop_x, :crop_y, :width, :height, :zoom, :cropBox_x, :cropBox_y, :cropBox_width, :cropBox_height])
  end
end

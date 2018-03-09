class Panel::EventsContainersController < Panel::BaseController
  before_action :set_events_container, only: [:show, :edit, :update, :destroy, :sort]

  def index
    authorize! :read, EventsContainer
    @events_containers = EventsContainerQuery.new(events_container_search_params).results
  end

  def show
    authorize! :read, @events_container
    @events = @events_container.events.order("position ASC")
  end

  def new
    authorize! :create, EventsContainer
    @form = Panel::CreateEventsContainerForm.new
  end

  def create
    authorize! :create, EventsContainer
    @form = Panel::CreateEventsContainerForm.new(events_container_form_params)
    service = Panel::CreateEventsContainerService.new(@form, current_user)

    if service.call
      redirect_to panel_events_containers_path, notice: _('Container was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @events_container
    @form = Panel::UpdateEventsContainerForm.new(events_container_attributes)
  end

  def update
    authorize! :update, @events_container
    @form = Panel::UpdateEventsContainerForm.new(
        events_container_attributes,
        events_container_form_params
    )
    service = Panel::UpdateEventsContainerService.new(@events_container, @form)

    if service.call
      redirect_to panel_events_containers_path, notice: _('Events Container was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @events_container

    Panel::DestroyEventsContainerService.new(@events_container).call

    redirect_to panel_events_containers_path, notice: _('Events Container was successfully deleted.')
  end

  def sort
    authorize! :update, @events_container
    service = Panel::SortEventsContainerService.new(@events_container, sort_params)
    service.call
    render nothing: true
  end

  private

  def set_events_container
    @events_container = EventsContainer.find(params[:id])
  end

  def events_container_search_params
    params.permit(:sort, :direction, :search).merge(admin_id: current_admin.id)
  end

  def sort_params
    params.require(:order)
  end

  def events_container_attributes
    @events_container.slice(
      'id', 'name'
    ).merge(linked_events: @events_container.linked_events.select(:id, :event_id, :position))
  end

  def events_container_form_params
    params.fetch(:events_container_form, {}).permit(
      :name, linked_events_attributes: [:id, :event_id, :position]
    )
  end

  def sort_column
    ['created_at', 'name', 'events'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end

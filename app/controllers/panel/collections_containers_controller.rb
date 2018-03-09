class Panel::CollectionsContainersController < Panel::BaseController
  before_action :set_collections_container, only: [:show, :edit, :update, :destroy, :sort]

  def index
    authorize! :read, CollectionsContainer
    @collections_containers = CollectionsContainerQuery.new(collections_container_search_params).results
  end

  def show
    authorize! :read, @collections_container
    @collections = @collections_container.collections.order("position ASC")
  end

  def new
    authorize! :create, CollectionsContainer
    @form = Panel::CreateCollectionsContainerForm.new
  end

  def create
    authorize! :create, CollectionsContainer
    @form = Panel::CreateCollectionsContainerForm.new(collections_container_form_params)
    service = Panel::CreateCollectionsContainerService.new(@form, current_user)

    if service.call
      redirect_to panel_collections_containers_path, notice: _('Container was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @collections_container
    @form = Panel::UpdateCollectionsContainerForm.new(collections_container_attributes)
  end

  def update
    authorize! :update, @collections_container
    @form = Panel::UpdateCollectionsContainerForm.new(
      collections_container_attributes,
      collections_container_form_params
    )
    service = Panel::UpdateCollectionsContainerService.new(@collections_container, @form)

    if service.call
      redirect_to panel_collections_containers_path,
                  notice: _('Collections Container was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @collections_container

    Panel::DestroyCollectionsContainerService.new(@collections_container).call

    redirect_to panel_collections_containers_path,
                notice: _('Collections Container was successfully deleted.')
  end

  def sort
    authorize! :update, @collections_container
    service = Panel::SortCollectionsContainerService.new(@collections_container, sort_params)
    service.call
    render nothing: true
  end

  private

  def set_collections_container
    @collections_container = CollectionsContainer.find(params[:id])
  end

  def collections_container_search_params
    params.permit(:sort, :direction, :search, :page).merge(admin_id: current_admin.id)
  end

  def sort_params
    params.require(:order)
  end

  def collections_container_attributes
    @collections_container.slice(
      'id', 'name'
    ).merge(linked_collections: @collections_container.linked_collections.select(:id, :collection_id, :position))
  end

  def collections_container_form_params
    params.fetch(:collections_container_form, {}).permit(
      :name, linked_collections_attributes: [:id, :collection_id, :position]
    )
  end

  def sort_column
    ['created_at', 'name', 'collections'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end

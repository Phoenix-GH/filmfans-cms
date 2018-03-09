class Panel::MediaOwnerTrendingContainersController < Panel::BaseController
  before_action :set_manual_post_container, only: [:show, :edit, :update, :destroy, :sort]

  def index
    authorize! :read, ManualPostContainer
    @manual_post_containers = ManualPostContainerQuery.new(manual_post_container_search_params).results
  end

  def new
    authorize! :create, ManualPostContainer
    @form = Panel::CreateManualPostContainerForm.new
  end

  def create
    authorize! :create, ManualPostContainer
    @form = Panel::CreateManualPostContainerForm.new(manual_post_container_form_params)
    service = Panel::CreateManualPostContainerService.new(@form)

    if service.call
      redirect_to panel_media_owner_trending_containers_path, notice: _('Container was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @manual_post_container
    @form = Panel::UpdateManualPostContainerForm.new(manual_post_container_attributes)
  end

  def update
    authorize! :update, @manual_post_container
    @form = Panel::UpdateManualPostContainerForm.new(
        manual_post_container_attributes,
        manual_post_container_form_params
    )
    service = Panel::UpdateManualPostContainerService.new(@manual_post_container, @form)

    if service.call
      redirect_to panel_media_owner_trending_containers_path, notice: _('Trending Container was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @manual_post_container

    Panel::DestroyMediaOwnerTrendingContainerService.new(@manual_post_container).call

    redirect_to panel_media_owner_trending_containers_path, notice: _('Trending Container was successfully deleted.')
  end

  def sort
    authorize! :update, @manual_post_container
    service = Panel::SortMediaOwnerTrendingContainerService.new(@manual_post_container, sort_params)
    service.call
    render nothing: true
  end

  private

  def set_manual_post_container
    @manual_post_container = ManualPostContainer.find(params[:id])
  end

  def manual_post_container_search_params
    params.permit(:sort, :direction, :search)
  end

  def sort_params
    params.require(:order)
  end

  def manual_post_container_attributes
    @manual_post_container.slice(
        'id', 'name'
    ).merge(linked_manual_posts: @manual_post_container.linked_manual_posts.select(:id, :manual_post_id, :position))
  end

  def manual_post_container_form_params
    params.fetch(:manual_post_container_form, {}).permit(
        :name, linked_manual_posts_attributes: [:id, :manual_post_id, :position]
    )
  end

  def sort_column
    ['created_at', 'name', 'posts'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end

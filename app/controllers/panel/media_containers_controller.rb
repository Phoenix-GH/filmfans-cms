class Panel::MediaContainersController < Panel::BaseController
  before_action :set_media_container, only: [:show, :edit, :update, :destroy]
  before_action :set_presenter, only: [:new, :create, :edit, :update]

  def index
    @media_containers = MediaContainerQuery.new(media_container_search_params).results
    @owners_for_select = MediaContainer.where('owner_id is not null').all.map{|mc| [mc.owner&.name, mc.owner&.id]}.uniq
  end

  def show
    authorize! :read, @media_container
  end

  def new
    authorize! :create, MediaContainer
    @form =  Panel::CreateMediaContainerForm.new
  end

  def create
    authorize! :create, MediaContainer
    @form = Panel::CreateMediaContainerForm.new(media_container_form_params)
    service = Panel::CreateMediaContainerService.new(@form)

    if service.call
      redirect_to panel_media_containers_path, notice: _('Media Container was successfully created.')
    else
      set_cover_image_params(@form.media_content)
      render :new
    end
  end

  def edit
    authorize! :update, @media_container
    @form = Panel::UpdateMediaContainerForm.new(media_container_attributes)
    set_cover_image_params(@media_container.media_content)
  end

  def update
    authorize! :update, @media_container
    @form = Panel::UpdateMediaContainerForm.new(
      media_container_attributes,
      media_container_form_params
    )
    service = Panel::UpdateMediaContainerService.new(@media_container, @form)

    if service.call
      redirect_to panel_media_containers_path, notice: _('Media Container was successfully updated.')
    else
      set_cover_image_params(@form.media_content)
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @media_container
    @media_container.destroy

    redirect_to panel_media_containers_path, notice: _('Media Container was successfully deleted.')
  end

  private
  def set_media_container
    @media_container = MediaContainer.find(params[:id])
  end

  def set_cover_image_params(content)
    return if content.nil?

    @image_params = {
      id: content.id,
      name: File.basename(content.file.url),
      size: content.file.size,
      src: content.cover_image.small_thumb.url
    }
  end

  def media_container_search_params
    params.permit(:sort, :direction, :search, :media_content_type, :owner_id, :page)
      .merge(channel_ids: current_admin.channel_ids)
      .merge(media_owner_ids: current_admin.media_owner_ids)
  end

  def media_container_attributes
    @media_container.slice(
      'owner', 'name', 'description', 'additional_description'
    )
  end

  def media_container_form_params
    params.require(:media_container_form).permit(
      :owner, :name, :description, :additional_description, :media_content_id
    )
  end

  def set_presenter
    @presenter = AdminPresenter.new(current_admin)
  end

  def sort_column
    ['created_at', 'name'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end

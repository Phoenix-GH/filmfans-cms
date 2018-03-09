class Panel::TagsController < Panel::BaseController
  before_action :set_media_container

  def new
    authorize! :update, @media_container
  end

  def create
    authorize! :update, @media_container
    service = Panel::ManageMediaContainerTagsService.new(
      @media_container, updated_tags_hash_params
    )

    respond_to do |format|
      if service.call
        format.html {
          redirect_to panel_media_container_path(@media_container),
          notice: _('Tags successfully updated.')
        }
        format.json { render json: true, status: :ok }
      else
        format.html { render action: :new }
        format.json { render json: false, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_media_container
    @media_container = MediaContainer.find(params[:media_container_id])
  end

  def updated_tags_hash_params
    params[:tags] ? params[:tags] : {}
  end
end

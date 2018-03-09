class Panel::MediaOwnersController < Panel::BaseController
  before_action :set_media_owner, only: [:show, :edit, :update, :destroy, :toggle_feed_active]

  def index
    @media_owners = MediaOwnerQuery.new(media_owners_search_params).results
  end

  def show
  end

  def new
    authorize! :create, MediaOwner
    @picture = MediaOwnerPicture.new
    @background_image = MediaOwnerBackgroundImage.new
    @form =  Panel::CreateMediaOwnerForm.new
  end

  def create
    authorize! :create, MediaOwner
    @form = Panel::CreateMediaOwnerForm.new(media_owner_form_params)
    service = Panel::CreateMediaOwnerService.new(@form, current_user)

    if service.call
      redirect_to panel_media_owners_path, notice: _('Media Owner was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @media_owner
    @picture = @media_owner.picture || @media_owner.create_picture
    @background_image = @media_owner.background_image || @media_owner.create_background_image
    @form = Panel::UpdateMediaOwnerForm.new(media_owner_attributes)
  end

  def update
    authorize! :update, @media_owner
    @form = Panel::UpdateMediaOwnerForm.new(
      media_owner_attributes,
      media_owner_form_params
    )
    service = Panel::UpdateMediaOwnerService.new(@media_owner, @form)

    if service.call
      redirect_to panel_media_owners_path, notice: _('Media Owner was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @media_owner
    @media_owner.destroy

    redirect_to panel_media_owners_path, notice: _('Media Owner was successfully deleted.')
  end

  def toggle_feed_active
    authorize! :update, @media_owner

    service = Panel::ToggleFeedActiveService.new(@media_owner)
    service.call

    respond_to do |format|
      format.js do
        render layout: false
      end
    end
  end

  def order
    authorize! :update, @media_owner
    @media_owners = MediaOwnerQuery.new(media_owners_search_params.merge({no_paging: true})).results
  end

  def save_order
    authorize! :update, @media_owner
    service = Panel::UpdatePositionService.new(MediaOwner, media_owner_order_params[:ordered_ids])

    if service.call
      redirect_to panel_media_owners_path,
                  notice: _('Celebrities were successfully ordered.')
    else
      redirect_to order_panel_media_owners_path,
                  alert: _('Failed to order celebrities!')
    end
  end

  private
  def set_media_owner
    @media_owner = MediaOwner.find(params[:id])
  end

  def media_owner_attributes
    @media_owner.slice('name', 'url', 'dialogfeed_url')
  end

  def media_owners_search_params
    params.permit(:sort, :direction, :search, :page).merge(media_owner_ids: current_admin.media_owner_ids)
  end

  def media_owner_form_params
    params.require(:media_owner_form).permit(:name, :url, :dialogfeed_url, picture: [:file], background_image: [:file])
  end

  def media_owner_order_params
    params.permit(:ordered_ids)
  end

  def sort_column
    ['name', 'feed_active'].include?(params[:sort]) ? params[:sort] : 'id'
  end
end

class Panel::MagazinesController < Panel::BaseController
  before_action :set_channel , only: [:index, :new, :create, :destroy, :show, :edit, :update]
  before_action :set_channel_from_form, only: [:create]
  before_action :set_magazine, only: [:show, :edit, :update, :destroy, :update_images]
  # before_action :set_presenter, only: [:new, :create, :edit, :update]

  def index
    @magazines = MagazineQuery.new(magazine_search_params).results
  end

  def new
    authorize! :update, @channel
    @cover_image = MagazineCoverImage.new
    @form = Panel::CreateMagazineForm.new
  end

  def order
    authorize! :update, @channel
    @magazines = MagazineQuery.new(magazine_search_params.merge({no_paging: true})).results
  end

  def save_order
    authorize! :update, @channel

    service = Panel::UpdatePositionService.new(Magazine, magazine_order_params[:ordered_ids])

    if service.call
      redirect_to panel_magazines_path(),
                  notice: _('Magazines were successfully ordered.')
    else
      redirect_to order_panel_magazines_path,
                  alert: _('Failed to order magazines!')
    end
  end

  def create
    authorize! :update, @channel

    @form = Panel::CreateMagazineForm.new(magazine_form_params.merge(channel_id: @channel.id))
    service = Panel::CreateMagazineService.new(@form, current_user)

    if service.call
      redirect_to panel_channel_magazines_path(service.magazine.channel),
        notice: _('Magazine was successfully created.')
    else
      @channel = nil if params[:magazine_form][:form_type] == 'no_channel'
      render :new
    end
  end

  def edit
    authorize! :update, @channel

    @form = Panel::UpdateMagazineForm.new(magazine_attributes)
    @cover_image = @magazine.cover_image

    render :edit
  end

  def update
    authorize! :update, @channel

    @form = Panel::UpdateMagazineForm.new(
      magazine_attributes,
      magazine_form_params.merge(channel_id: @channel.id)
    )
    service = Panel::UpdateMagazineService.new(@magazine, @form)

    if service.call
      redirect_to panel_channel_magazines_path(@channel),
        notice: _('Magazine was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    authorize! :update, @channel
    @magazine.destroy

    redirect_to panel_channel_magazines_path(@channel), notice: _('Magazine was successfully deleted.')
  end

  def update_images
    @magazine.cover_image.update_attributes(cover_image_params)
    @magazine.cover_image.file.recreate_versions!
    @magazine.background_image.update_attributes(background_image_params)
    @magazine.background_image.file.recreate_versions!

    render 'cover_image', layout: false
  end

  private

  def set_channel
    @channel = Channel.find(params[:channel_id]) if params[:channel_id]
  end

  def set_channel_from_form
    @channel = Channel.find(params[:magazine_form][:channel_id]) unless @channel.present?
  end

  def set_magazine
    @magazine = Magazine.find(params[:id])
  end

  def set_presenter
    @presenter = AdminPresenter.new(current_admin)
  end

  def magazine_attributes
    @magazine.slice('title', 'description', 'channel_id')
  end

  def cover_image_params
    params.require(:cover_image).permit(specification: [:crop_x, :crop_y, :width, :height, :zoom, :cropBox_x, :cropBox_y, :cropBox_width, :cropBox_height])
  end

  def background_image_params
    params.require(:background_image).permit(specification: [:crop_x, :crop_y, :width, :height, :zoom, :cropBox_x, :cropBox_y, :cropBox_width, :cropBox_height])
  end

  def magazine_search_params
    params.permit(:sort, :direction, :search, :channel_id, :page).merge(channel_ids: current_admin.channel_ids)
  end

  def magazine_form_params
    params.require(:magazine_form).permit(:title, :description, cover_image: [:file])
  end

  def sort_column
    ['title'].include?(params[:sort]) ? params[:sort] : 'id'
  end

  def magazine_order_params
    params.permit(:ordered_ids)
  end
end

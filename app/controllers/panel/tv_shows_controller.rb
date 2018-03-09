class Panel::TvShowsController < Panel::BaseController
  before_action :set_channel, only: [:index, :new, :create, :destroy, :show, :edit, :update]
  before_action :set_channel_from_form, only: [:create]
  before_action :set_tv_show, only: [:show, :edit, :update, :destroy, :update_images]
  # before_action :set_presenter, only: [:new, :create, :edit, :update]

  def index
    @tv_shows = TvShowQuery.new(tv_show_search_params).results
  end

  def order
    authorize! :update, @channel
    @tv_shows = TvShowQuery.new(tv_show_search_params.merge({no_paging: true})).results
  end

  def save_order
    authorize! :update, @channel

    service = Panel::UpdatePositionService.new(TvShow, tv_show_order_params[:ordered_ids])

    if service.call
      redirect_to panel_tv_shows_path(),
                  notice: _('TV Shows were successfully ordered.')
    else
      redirect_to order_panel_tv_shows_path,
                  alert: _('Failed to order TV Shows!')
    end
  end

  def new
    authorize! :update, @channel
    @background_image = TvShowBackgroundImage.new
    @form = Panel::CreateTvShowForm.new
  end

  def create
    authorize! :update, @channel

    @form = Panel::CreateTvShowForm.new(tv_show_form_params.merge(channel_id: @channel.id))
    service = Panel::CreateTvShowService.new(@form, current_user)

    if service.call
      redirect_to panel_channel_tv_shows_path(service.tv_show.channel),
        notice: _('TV Show was successfully created.')
    else
      @channel = nil if params[:tv_show_form][:form_type] == 'no_channel'
      render :new
    end
  end

  def edit
    authorize! :update, @channel

    @form = Panel::UpdateTvShowForm.new(tv_show_attributes)
    @background_image = @tv_show.background_image

    render :edit
  end

  def update
    authorize! :update, @channel

    @form = Panel::UpdateTvShowForm.new(
      tv_show_attributes,
      tv_show_form_params.merge(channel_id: @channel.id)
    )
    service = Panel::UpdateTvShowService.new(@tv_show, @form)

    if service.call
      redirect_to panel_channel_tv_shows_path(@channel),
        notice: _('Tv Show was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    authorize! :update, @channel
    @tv_show.destroy

    redirect_to panel_channel_tv_shows_path(@channel), notice: _('TV Show was successfully deleted.')
  end

  def update_images
    @tv_show.cover_image.update_attributes(cover_image_params)
    @tv_show.cover_image.file.recreate_versions!
    @tv_show.background_image.update_attributes(background_image_params)
    @tv_show.background_image.file.recreate_versions!

    render 'background_image', layout: false
  end

  private

  def set_channel
    @channel = Channel.find(params[:channel_id]) if params[:channel_id]
  end

  def set_channel_from_form
    @channel = Channel.find(params[:tv_show_form][:channel_id]) unless @channel.present?
  end

  def set_tv_show
    @tv_show = TvShow.find(params[:id])
  end

  def set_presenter
    @presenter = AdminPresenter.new(current_admin)
  end

  def tv_show_attributes
    @tv_show.slice('title', 'description', 'channel_id')
  end

  def cover_image_params
    params.require(:cover_image).permit(specification: [:crop_x, :crop_y, :width, :height, :zoom, :cropBox_x, :cropBox_y, :cropBox_width, :cropBox_height])
  end

  def background_image_params
    params.require(:background_image).permit(specification: [:crop_x, :crop_y, :width, :height, :zoom, :cropBox_x, :cropBox_y, :cropBox_width, :cropBox_height])
  end

  def tv_show_search_params
    params.permit(:sort, :direction, :search, :channel_id, :page).merge(channel_ids: current_admin.channel_ids)
  end

  def tv_show_form_params
    params.require(:tv_show_form).permit(:title, :description, background_image: [:file])
  end

  def sort_column
    ['title'].include?(params[:sort]) ? params[:sort] : 'id'
  end

  def tv_show_order_params
    params.permit(:ordered_ids)
  end
end

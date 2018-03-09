class Panel::ChannelsController < Panel::BaseController
  before_action :set_channel, only: [:show, :edit, :update, :destroy, :toggle_feed_active, :toggle_visibility, :feed_settings]
  before_action :set_presenter, only: [:index, :new, :create, :edit, :update]

  def order
    authorize! :update, Channel
    @channels = ChannelQuery.new(channels_search_params.merge({no_paging: true, normal: true})).results
  end

  def save_order
    authorize! :update, Channel
    service = Panel::UpdatePositionService.new(Channel, save_order_params[:ordered_ids])

    if service.call
      redirect_to panel_channels_path,
                  notice: _('Channel was successfully ordered.')
    else
      redirect_to order_panel_channels_path,
                  alert: _('Failed to order channels!')
    end
  end

  def index
    authorize! :read, Channel
    @channels = ChannelQuery.new(channels_search_params).results
    @country_code_to_name = Hash.new
    Country.all.each do |c|
      @country_code_to_name[c.code] = c.name
    end
  end

  def show
    authorize! :read, @channel
  end

  def new
    authorize! :create, Channel
    @picture = ChannelPicture.new
    @form =  Panel::CreateChannelForm.new
  end

  def create
    authorize! :create, Channel
    @form = Panel::CreateChannelForm.new(channel_form_params)
    service = Panel::CreateChannelService.new(@form, current_user)

    if service.call
      redirect_to feed_panel_channel_posts_path(service.channel),
        notice: _('Channel was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @channel
    step = params['step'] || 'edit'

    if step == 'edit'
      @form = Panel::UpdateChannelForm.new(channel_attributes)
      @picture = @channel.picture || @channel.create_picture
      render :edit
    elsif step == 'trending'
      @form = Panel::UpdateTrendingForm.new(trending_attributes)
      render :trending
    end
  end

  def update
    authorize! :update, @channel

    step = params['step'] || 'update'
    if step == 'update'
      @form = Panel::UpdateChannelForm.new(
        channel_attributes,
        channel_form_params
      )
      service = Panel::UpdateChannelService.new(@channel, @form)

      if service.call
        redirect_to feed_panel_channel_posts_path(@channel),
          notice: _('Channel was successfully updated.')
      else
        render :edit
      end
    elsif step == 'trending'
      @form = Panel::UpdateTrendingForm.new(
        trending_attributes,
        trending_form_params
      )

      service = Panel::UpdateTrendingService.new(@channel.trending, @form)

      if service.call
        redirect_to panel_channel_tv_shows_path(@channel),notice: _('Trending was successfully created.')
      else
        render :trending
      end
    else
      redirect_to panel_channels_path
    end
  end

  def destroy
    authorize! :destroy, @channel
    @channel.destroy

    redirect_to panel_channels_path, notice: _('Channel was successfully deleted.')
  end

  def toggle_feed_active
    authorize! :update, @channel

    service = Panel::ToggleFeedActiveService.new(@channel)
    service.call

    respond_to do |format|
      format.js do
        render layout: false
      end
    end
  end

  def toggle_visibility
    authorize! :update, @channel

    service = Panel::ToggleService.new(@channel, :visibility)
    service.call

    respond_to do |format|
      format.js do
        render layout: false
      end
    end
  end

  def feed_settings
    authorize! :update, @channel

    service = Panel::UpdateFeedSettingsService.new(@channel, feed_settings_params)

    if service.call
      respond_to do |format|
        format.json do
          head :ok
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {message: 'Failed to save channel'}, status: 422
        end
      end
    end

  end

  private
  def set_channel
    @channel = Channel.find(params[:id])
  end

  def set_presenter
    @presenter = AdminPresenter.new(current_admin)
  end

  def channel_attributes
    attrs = @channel.slice('name', 'media_owner_ids', 'dialogfeed_url', 'countries', 'visibility')
    if attrs[:countries].blank?
      attrs[:countries] = [Country::CODE_GLOBAL]
    end
    attrs
  end

  def trending_attributes
    @channel.create_trending unless @channel.trending
    { trending_contents: @channel.trending.trending_contents.order(:position)
      .select(:id, :content_type, :content_id, :position, :width)
    }
  end

  def trending_form_params
    return params.permit(:trending_form) if params[:trending_form].blank?

    params.require(:trending_form).permit(
      trending_contents_attributes:
      [:content_type, :content_id, :_destroy, :id, :position, :width]
    )
  end

  def channels_search_params
    params.permit(:sort, :direction, :search, :page, :country).merge(channel_ids: current_admin.channel_ids)
  end

  def save_order_params
    params.permit(:ordered_ids).merge(channel_ids: current_admin.channel_ids)
  end

  def channel_form_params
    params.require(:channel_form).permit(:name, :dialogfeed_url, :visibility, countries: [], media_owner_ids: [], picture: [:file])
  end

  def feed_settings_params
    params.require(:channel_form).permit(:dialogfeed_url, :feed_active, :visibility)
  end

  def sort_column
    ['name', 'feed_active', 'media_owners', 'visibility'].include?(params[:sort]) ? params[:sort] : 'id'
  end
end

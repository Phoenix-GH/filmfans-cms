class Panel::EpisodesController < Panel::BaseController
  before_action :set_episode,   only: [:destroy, :show, :edit, :update]
  before_action :set_tv_show,   only: [:index, :new, :create, :destroy, :show, :edit, :update]
  before_action :set_channel ,  only: [:index, :new, :create, :destroy, :show, :edit, :update]
  # before_action :set_presenter, only: [:new, :create, :edit, :update]

  def index
    @episodes = @tv_show.episodes.all # EpisodeQuery.new(episode_search_params).results
    if @episodes.blank?
      redirect_to action: :new and return
    end
  end

  def new
    authorize! :update, @channel
    @form = Panel::CreateEpisodeForm.new
  end

  def create
    authorize! :update, @channel

    @form = Panel::CreateEpisodeForm.new(episode_form_params.merge(tv_show_id: @tv_show.id))
    service = Panel::CreateEpisodeService.new(@form, current_user)

    if service.call
      redirect_to panel_tv_show_episodes_path(service.episode.tv_show_season.tv_show_id),
        notice: _('Episode was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @channel

    @form = Panel::UpdateEpisodeForm.new(episode_attributes)

    render :edit
  end

  def update
    authorize! :update, @channel

    @form = Panel::UpdateEpisodeForm.new(
      episode_attributes,
      episode_form_params.merge(tv_show_id: @tv_show.id)
    )
    service = Panel::UpdateEpisodeService.new(@episode, @form)

    if service.call
      redirect_to panel_tv_show_episodes_path(service.episode.tv_show_season.tv_show_id),
        notice: _('Episode was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    authorize! :update, @channel
    @episode.destroy

    redirect_to panel_tv_show_episodes_path(@tv_show), notice: _('Episode was successfully deleted.')
  end

  private

  def set_episode
    @episode = Episode.find(params[:id])
  end

  def set_tv_show
    @tv_show = TvShow.find(params[:tv_show_id])
  end

  def set_channel
    @channel = @tv_show.channel
  end

  def set_presenter
    @presenter = AdminPresenter.new(current_admin)
  end

  def episode_attributes
    @episode.slice('tv_show_season_id', 'file', 'title', 'number', 'specification')
  end

  # def episode_search_params
  #   params.permit(:sort, :direction, :search).merge(channel_ids: current_admin.channel_ids)
  # end

  def episode_form_params
    params.require(:episode_form).permit(:title, :tv_show_season_number, :number, :file, :file_cache)
  end

end


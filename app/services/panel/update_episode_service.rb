class Panel::UpdateEpisodeService
  attr_reader :episode

  def initialize(episode, form)
    @episode = episode
    @form = form
  end

  def call
    return false unless @form.valid?

    get_tv_show_season
    update_episode
  end

  private

  def get_tv_show_season
    @tv_show = TvShow.find(@form.tv_show_id)
    @tv_show_season = @tv_show.tv_show_seasons.find_or_create_by(
                                      number: @form.tv_show_season_number)
  end

  def update_episode
    @episode.update_attributes(@form.attributes_for_create.merge(
                                      tv_show_season_id: @tv_show_season.id))
    @episode.file.recreate_versions!
    @episode.save
  end

end

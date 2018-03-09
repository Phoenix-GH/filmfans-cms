class Panel::CreateEpisodeService
  attr_reader :episode

  def initialize(form, user)
    @form = form
    @user = user
  end

  def call
    return false unless @form.valid?

    get_tv_show_season
    create_episode
  end

  private

  def get_tv_show_season
    @tv_show = TvShow.find(@form.tv_show_id)
    @tv_show_season = @tv_show.tv_show_seasons.find_or_create_by(
                                      number: @form.tv_show_season_number)
  end

  def create_episode
    @episode = Episode.create(@form.attributes_for_create.merge(
                                    tv_show_season_id: @tv_show_season.id))
  end
end

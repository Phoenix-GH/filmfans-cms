class TvShowSerializer
  def initialize(tv_show, with_episodes: false)
    @tv_show = tv_show
    @with_episodes = with_episodes
  end

  def results
    return '' unless @tv_show
    generate_tv_show_json
    add_episodes

    @tv_show_json
  end

  private
  def generate_tv_show_json
    @tv_show_json = {
      id: @tv_show.id,
      name: @tv_show.title.to_s,
      description: @tv_show.description.to_s,
      episodes_count: @tv_show.episodes.count.to_i,
      seasons_count: @tv_show.seasons.count.to_i,
      thumbnail_url: @tv_show.cover_image.present? ? @tv_show.cover_image.custom_url : '',
      channel: channel_details
    }
  end

  def channel_details
    return {} unless @tv_show.channel
    {
      id: @tv_show.channel_id,
      name: @tv_show.channel.name.to_s,
      thumbnail_url: @tv_show.channel&.picture.present? ? @tv_show.channel.picture.custom_url : ''
    }
  end

  def add_episodes
    return unless @with_episodes

    seasons = @tv_show.seasons.map do |season|
      TvShowSeasonSerializer.new(season).results
    end

    seasons.reject! { |season| season[:season_episodes_count] == 0 }

    @tv_show_json.merge!(
        {
            episodes_count: seasons.inject(0) { |sum, season| sum += season[:season_episodes_count] },
            seasons_count: seasons.size,
            seasons: seasons
        })
  end
end
